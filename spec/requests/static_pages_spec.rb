require 'spec_helper'

describe "Static pages" do
  
  subject { page }
  
  describe "Home page" do

    before { visit root_path }

    it { should have_selector('h1',    text: 'Welcome to the Walk30 Experiment') }
    it { should have_selector 'title', text: '| Welcome' }
    
    describe "click sign up" do
      before{click_link "Sign up now!"}
      it { should have_selector('title', text: '| Sign Up') }      
    end

    describe "click contact" do
      before{click_link "Contact"}
      it { should have_selector('title', text: '| Contact') }      
    end    
          
      
  end
end
