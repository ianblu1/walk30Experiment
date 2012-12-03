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
  
  validates :content, length: { maximum: 140 }, :if => :textMessage?
  validates :subject, length: { maximum: 0 }, :if => :textMessage?

  validates :subject, length: { maximum: 140 }, :if => :email?
  
  def self.deliverAllPendingScheduledBeforeNow()
    i = 0
    for message in Message.find_all_by_status(PENDING)
      if message.scheduled_at.past?
        message.deliverMessage
        i = i+1
      end
    end
    return i
  end
  
  def textMessage? 
    medium==TEXT
  end

  def email? 
    medium==EMAIL
  end
  
  def test?
    medium==TEST
  end
  
  def delivered?
    status==DELIVERED
  end
  
  def received?
    status==RECEIVED
  end
  
  def pending?
    status==PENDING
  end
  
  def failed?
    status==FAILED
  end
  
  def mediumString
    if self.textMessage?
      return "TEXT"
    elsif self.email?
      return "EMAIL"
    elsif self.test?
      return "TEST"
    end
  end
  
  def statusString
    if self.pending?
      return "PENDING"
    elsif self.received?
      return "RECEIVED"
    elsif self.delivered?
      return "DELIVERED"
    elsif self.failed?
      return "FAILED"
    end
  end
  
  def summaryString
    if self.textMessage?
      return self.content
    elsif self.test?
      return self.content
    elsif self.email?
      return self.subject
    end
  end
  
  def timeString
    if self.pending?
      return self.scheduled_at
    else
      return self.sent_at
    end
  end 
  
  def deliverMessage()
    delivered = FALSE
    if self.status == PENDING
      if medium == TEXT
        delivered = self.deliverTwilioMessage
      elsif medium == EMAIL
        delivered = self.deliverEmailMessage
      elsif medium == TEST
        delivered = self.deliverTestMessage
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
    return delivered
  end

  
  protected
  
  def deliverTestMessage()
    self.status = DELIVERED
    self.sent_at = DateTime.now()
    puts 'TEST message with content: "' + self.content + '" delivered.'
    return true
  end
  
  def deliverTwilioMessage()
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

  def deliverEmailMessage
    self.status = FAILED
    self.save
    puts "Email not yet enabled"
    return false
  end
  
end
