class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_path
  end 
  
  def after_sign_in_path_for(resource)
      participants_path
  end
  
 
  
end
