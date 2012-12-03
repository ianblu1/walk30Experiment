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
  TEST = 2
  
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
  
  def self.sendAllPendingScheduledBeforeNow()
    i = 0
    for message in Message.find_all_by_status(PENDING)
      if message.scheduled_at.past?
        message.sendMessage
        i = i+1
      end
    end
    return i
  end
  
  def isTextMessage? 
    medium==TEXT
  end

  def isEmail? 
    medium==EMAIL
  end
  
  def isTest?
    medium==TEST
  end
  
  def sendMessage()
    sent = FALSE
    if self.status == PENDING
      if medium == TEXT
        sent = self.sendTwilioMessage
      elsif medium == EMAIL
        sent = self.sendEmailMessage
      elsif medium == TEST
        sent = self.sendTestMessage
      end
      self.sent_at = DateTime.now
      self.save
    elsif self.status == DELIVERED
      puts "Cannot deliver message. Message has already been delivered."
    elsif self.status == RECEIVED
      puts "Cannot deliver message. Message was received."
    elsif self.status == FAILED
      puts "Cannot deliver message. Message failed on previous delivery."
    end
    return sent
  end

  
  protected
  
  def sendTestMessage()
    self.status = DELIVERED
    self.sent_at = DateTime.now()
    puts 'TEST message with content: "' + self.content + '" delivered.'
    return true
  end
  
  def sendTwilioMessage()
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

  def sendEmailMessage
    self.status = FAILED
    self.save
    puts "Email not yet enabled"
    return false
  end
  
end
