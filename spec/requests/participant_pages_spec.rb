require 'spec_helper'

describe "Participant pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector 'title', text: '| Sign Up' }
      
    let(:submit) { "Enroll Me!" }

    describe "with invalid information" do
      it "should not create a participant" do
        expect { click_button submit }.not_to change(Participant, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Email",        with: "participant@example.com"
        fill_in "Phone Number",     with: "987-654-3210"
        fill_in "Zip Code", with: "90210"
        fill_in "Age", with: 40
        choose("participant_is_male_false")
      end

      it "should create a participant" do
        expect { click_button submit }.to change(Participant, :count).by(1)
      end
    end
      
      
  end
end
