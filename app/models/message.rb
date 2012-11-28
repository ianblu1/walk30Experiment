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

class Message < ActiveRecord::Base
  attr_accessible :content, :medium, :status, :scheduled_at, :subject
  belongs_to :participant
  
  #message mediums
  TEXT = 0
  EMAIL = 1
  
  #message status codes
  PENDING = 0
  DELIVERED = 1
  RECEIVED = 2
  FAILED = 3    
  
  validates :participant_id, presence:true
  validates :medium, presence:true
  validates :status, presence:true

  validates :content, presence: true
  
  validates :content, length: { maximum: 140 }, :if => :isTextMessage?
  validates :subject, length: { maximum: 0 }, :if => :isTextMessage?

  validates :subject, length: { maximum: 140 }, :if => :isEmail?
  
  def isTextMessage? 
    medium==TEXT
  end

  def isEmail? 
    medium==EMAIL
  end
  
  def deliver()
    if self.status == PENDING
      if medium == TEXT
        return self.deliverUsingTwilio
      else
        return self.deliverUsingMailer
      end
    elsif self.status == DELIVERED
      puts "Cannot deliver message. Message has already been delivered."
    elsif self.status == RECEIVED
      puts "Cannot deliver message. Message was received."
    elsif self.status == FAILED
      puts "Cannot deliver message. Message failed on previous delivery."
    end
    return false
  end
  
  protected
  def deliverUsingTwilio()
    from = '+14156973206'
    to = '+1' + self.participant.phone
    body = self.content
    
    @account_sid = 'ACdec6d1b743c5ff2efe53908fdf2f2459'
    @auth_token = 'c0fc9928e631451677a1dcf713c54c54'
    @client = Twilio::REST::Client.new(@account_sid, @auth_token)
    
    twilio_message = @client.account.sms.messages.create({:from => from, :to => to, :body =>body})
    if twilio_message.status == "queued"
      self.status = DELIVERED
      self.save
      puts "Twilio message delivered."
      return true
    else
      self.status = FAILED
      self.save
      puts "Twilio message failed"
      return false
    end
  end

  def deliverUsingMailer
    self.status = FAILED
    self.save
    puts "Email not yet enabled"
    return false
  end
  
end
