Walk30Experiment::Application.routes.draw do
  
  devise_for :users, :controllers => { :registrations => "users/registrations" }
  devise_scope :user do
    match "/login", to: "devise/sessions#new"
  end
  
  resources :robot_participants, :controller => "participants", :type => "RobotParticipant"
  
  resources :participants do
    collection do
      get :summary
      put :setNextDay
    end
    member do
      put :activate
      put :terminate
      put :reactivate
      post :deliverMessage
    end
  end

  post "/twilio/receive/" => "participants#twilio_receive"



  resources :messages do
    member do
      put :deliver
      put :flagPositive
      put :flagNegative
      put :flagNeutral
    end
  end
  
  resources :project_messages, :controller => "messages", :type => "ProjectMessage" do
    member do
      put :deliver
      put :flagPositive
      put :flagNegative
      put :flagNeutral
    end
  end

  #get "static_pages/home"
  root to: 'static_pages#home'
  match '/contact', to: 'static_pages#contact'
  match '/signup', to: "participants#new"
  match '/instructions', to: 'static_pages#instructions'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
