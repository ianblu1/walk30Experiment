require 'spec_helper'

describe "Participant pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector 'title', text: '| Sign Up' }
      
    let(:submit) { "Sign Me Up!" }

    describe "with invalid information" do
      it "should not create a participant" do
        expect { click_button submit }.not_to change(Participant, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Email",        with: "participant@example.com"
        fill_in "Cellphone Number",     with: "650-704-8903"
        choose("participant_morning_reminder_true")
        fill_in "Zip Code/Area Code", with: "90210"
        fill_in "Time Zone Abbreviation (Example: PST, EST)", with:"PST"
        fill_in "Age", with: 40
        choose("participant_is_male_false")
        
      end

      it "should create a participant" do
        expect { click_button submit }.to change(Participant, :count).by(1)
      end
    end
    
    
    describe "with invalid phone number information" do
      before do
        fill_in "Email",        with: "participant1@example.com"
        fill_in "Cellphone Number",     with: "555-555-5555"
        choose("participant_morning_reminder_true")
        fill_in "Zip Code/Area Code", with: "90210"
        fill_in "Time Zone Abbreviation (Example: PST, EST)", with:"PST"
        fill_in "Age", with: 40
        choose("participant_is_male_false")
        
      end

      it "should not create a participant" do
        expect { click_button submit }.to change(Participant, :count).by(0)
      end
    end
      
      
  end
end
