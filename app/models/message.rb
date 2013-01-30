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
  attr_accessible :content, :medium, :status, :scheduled_at, :sent_at, :subject, :type
  belongs_to :participant
  
  #twilio config info
  TWILIO_ACCOUNT_SID = 'ACdec6d1b743c5ff2efe53908fdf2f2459'
  TWILIO_AUTH_TOKEN = 'c0fc9928e631451677a1dcf713c54c54'
  
  
  #message mediums
  TEST = 0
  TEXT = 1
  EMAIL = 2
    
  #message status codes
  PENDING = 0
  DELIVERED = 1
  RECEIVED = 2
  FAILED = 3    
  CANCELED = 4
  
  #message flags
  NEUTRAL = 0
  POSITIVE = 1
  NEGATIVE = 2
  
  
  validates :participant_id, presence:true
  validates :medium, presence:true
  validates :status, presence:true

  validates :content, presence: true
  
  validates :content, length: { maximum: 155 }, :if => :textMessage?
  validates :subject, length: { maximum: 0 }, :if => :textMessage?

  validates :subject, length: { maximum: 155 }, :if => :email?

  before_create {|message| 
                message.sent_at = DateTime.now if message.received?
                }
  
  def self.deliverAllPendingScheduledBeforeNow()
    i = 0
    for message in Message.find_all_by_status(PENDING)
      if message.scheduled_at.past?
        message.deliver
        i = i+1
      end
    end
    return i
  end
  
  def replies
    if self.sent_at
      ms = self.participant.messages.select {|m| m.sent_at and m.sent_at> self.sent_at}
      if self.delivered?
        upper_time = ms.select{|m| m.delivered? and m.sent_at}.map{|m| m.sent_at}.min
        upper_time = Time.now if not upper_time
        ms.select {|m| m.sent_at and m.sent_at < upper_time and m.received?}
      elsif self.received?
        upper_time = ms.select{|m| m.received? and m.sent_at}.map{|m| m.sent_at}.min
        upper_time = Time.now if not upper_time
        ms.select {|m| m.sent_at and m.sent_at < upper_time and m.delivered?}
      end
    end
  end
  
  def secondsSinceLastUpdate
    DateTime.now.to_f - self.updated_at.to_f
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
    
  def flagged?
    flag
  end

  def flagPositive
    self.flag=POSITIVE
    self.save
  end
  
  def flagPositive?
    flag==POSITIVE
  end
  
  def flagNegative
    self.flag=NEGATIVE
    self.save
  end
  
  def flagNegative?
    flag==NEGATIVE
  end
  
  def flagNeutral
    self.flag=NEUTRAL
    self.save
  end
  
  def flagNeutral?
    flag==NEUTRAL
  end
  
  def canceled?
    status==CANCELED
  end
  
  def cancel
    self.status=CANCELED
    self.save
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
    elsif self.canceled?
      return "CANCELED"
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
  
  def dateTimeForDisplay
    if self.pending?
      return self.scheduled_at
    elsif self.delivered?
      self.sent_at
    elsif self.received?
      self.sent_at
    else
      self.updated_at
    end
  end 
  
  def deliver()
    if not self.participant
      self.delete
      return
    end
    
    delivered = FALSE
    if self.status == PENDING
      if medium == TEXT
        delivered = self.deliverTwilioMessage
      elsif medium == TEST
        delivered = self.deliverTestMessage
      end
      if delivered
        self.sent_at = DateTime.now
        self.save
        self.participant.messageDelivered(self)
      end
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
    
    @client = Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
    
    begin 
      twilio_message = @client.account.sms.messages.create({:from => from, :to => to, :body =>body})
      if twilio_message.status == "queued"
        self.status = DELIVERED
        self.save
        puts "Twilio message delivered."
        return true
      else 
        raise
      end
    rescue 
      self.status = FAILED
      self.save
      puts "Twilio message failed"
      return false
    end
  end
end
