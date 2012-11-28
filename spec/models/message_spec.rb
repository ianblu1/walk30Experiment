# == Schema Information
#
# Table name: messages
#
#  id             :integer          not null, primary key
#  participant_id :integer
#  subject        :string(255)
#  content        :string(255)
#  medium         :integer
#  status         :integer
#  scheduled_at   :datetime
#  sent_at        :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Message do
  let(:participant) { FactoryGirl.create(:participant) }

  before do
    @message = participant.messages.build(content:"test",medium:Message::TEXT,status:Message::PENDING,scheduled_at:DateTime.now)
  end
  
  subject {@message}
  it { should respond_to(:participant_id)}
  it { should respond_to(:participant)}
  its(:content) { should == "test"}

  it {should be_valid}
  
  describe "accessible attributes" do
    it "should not allow access to participant_id" do
      expect do
        Message.new(participant_id: participant.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
  describe "text message with content too long" do
    before do
      @message.content = "a"*141
      @message.medium = Message::TEXT
    end
    it {should_not be_valid}
  end

  describe "text message with non-nil subject" do
    before do
      @message.subject = "a"*10
      @message.medium = Message::TEXT
    end
    it {should_not be_valid}
  end

  describe "email message very long subject" do
    before do
      @message.subject = "a"*150
      @message.medium = Message::EMAIL
    end
    it {should_not be_valid}
  end

  describe "emails should not be length-limited" do
    before do
      @message.content = "a"*141
      @message.subject = "b"*55
      @message.medium = Message::EMAIL
    end
    it {should be_valid}
  end

end
