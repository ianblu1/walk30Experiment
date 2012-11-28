# == Schema Information
#
# Table name: participants
#
#  id                  :integer          not null, primary key
#  email               :string(255)
#  age                 :integer
#  zip_code            :string(255)
#  is_male             :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  phone               :string(255)
#  status              :integer
#  experiment_begun_at :datetime
#  experiment_ended_at :datetime
#

require 'spec_helper'

describe Participant do
  before{@participant=Participant.new(email:"participant@example.com", is_male: true, phone: "987-654-3210",
    age: 31, zip_code:90210)}
    
  subject { @participant }
    
  it { should respond_to(:email) }
  it { should respond_to(:age) }
  it { should respond_to(:is_male) }
  it { should respond_to(:phone) }
  it { should respond_to(:zip_code) }
  it { should be_valid }

  describe "when email is not present" do
    before { @participant.email = " " }
    it { should_not be_valid }
  end  

  describe "when phone number is not present" do
    before { @participant.phone = " " }
    it { should_not be_valid }
  end  

  describe "when phone number is too short" do
    before { @participant.phone = "1" }
    it { should_not be_valid }
  end   
  
  describe "when phone number is too long" do
    before { @participant.phone = "1"*21 }
    it { should_not be_valid }
  end   
  
  describe "when phone number has letters" do
    before { @participant.phone = "a"*10 }
    it { should_not be_valid }
  end     
  
  describe "when email format is invalid" do
     it "should be invalid" do
       addresses = %w[participant@foo,com participant_at_foo.org example.participant@foo.
                      foo@bar_baz.com foo@bar+baz.com]
       addresses.each do |invalid_address|
         @participant.email = invalid_address
         @participant.should_not be_valid
       end      
     end
   end
   
   describe "when email format is valid" do
     it "should be valid" do
       addresses = %w[participant@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
       addresses.each do |valid_address|
         @participant.email = valid_address
         @participant.should be_valid
       end      
     end
   end
   
   describe "when email address is already taken" do
     before do
       participant_with_same_email = @participant.dup
       participant_with_same_email.save
     end
 
     it { should_not be_valid }
   end
   
   describe "when email address is already taken" do
     before do
       participant_with_same_email = @participant.dup
       participant_with_same_email.email = @participant.email.upcase
       participant_with_same_email.save
     end
 
     it { should_not be_valid }
   end  
  
end
