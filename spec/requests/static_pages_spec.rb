require 'spec_helper'

describe "Static pages" do
  
  subject { page }
  
  describe "Home page" do

    before { visit root_path }

    it { should have_selector('h1',    text: 'The Walk30 Experiment') }
    it { should have_selector 'title', text: '| Home' }
  end
end
