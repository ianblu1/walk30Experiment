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

class Participant < ActiveRecord::Base
  attr_accessible :age, :email, :is_male, :phone, :zip_code, :status, :morning_reminder, :walked_last_week
  has_many :messages  
  
  #Status values
  ACTIVE = 1
  TERMINATED = 2
  
  def activate
    if self.pending?
      self.status = ACTIVE
      self.experiment_begun_at = DateTime.now()
      self.save
    end
  end
  
  def terminate
    self.status = TERMINATED
    self.experiment_ended_at = DateTime.now()
    self.save
  end
  
  def pending?
    self.status==nil
  end
  
  def active? 
    self.status==ACTIVE
  end

  def terminated? 
    self.status==ACTIVE
  end
  
  def days_active
    if self.experiment_begun_at
      if self.experiment_ended_at
        return (self.experiment_ended_at.to_f - self.experiment_begun_at.to_f)/86400.0
      else
        return (DateTime.now.to_f - self.experiment_begun_at.to_f)/86400.0
      end
    end
    return nil
  end
  
  def days_since_terminated
    if self.experiment_ended_at
      return (DateTime.now.to_f - self.experiment_ended_at.to_f)/86400.0
    end
    return nil
  end

  def days_pending
    if self.experiment_begun_at
      return (self.days_pending - self.created_at.to_f)/86400.0
    elsif self.experiment_ended_at
      return (self.experiment_ended_at - self.created_at.to_f)/86400.0
    else
      return (DateTime.now.to_f - self.created_at.to_f)/86400.0
    end
  end
  
  def statusString
    if self.active?
      return "ACTIVE"
    elsif self.terminated?
      return "TERMINATED"
      self.days_active.round.to_s
    elsif self.pending?
      return "PENDING"
    end
  end
  
  def daysInStatus
    if self.active?
      return self.days_active
    elsif self.terminated?
      return self.days_terminated
      self.days_active.round.to_s
    elsif self.pending?
      return self.days_pending
    end
  end
  
  def deliveredMessages
    return self.messages.where('status = ?',Message::DELIVERED)
  end

  def receivedMessages
    return self.messages.where('status = ?',Message::RECEIVED)
  end

  def pendingMessages
    return self.messages.where('status = ?',Message::PENDING)
  end
  
  def testMessageWithDelayInMinutes(content,delay)
    time = DateTime.now() + delay/24/60
    pendingMessageWithTime(content,Message::TEST,time)
    return 
  end
        
  def deliverMessage(content,medium)
    message = self.messages.build(content:content,medium:medium,status:Message::PENDING,scheduled_at:DateTime.now)
    message.save
    return message.deliver()
  end
  
  def pendingMessageWithTime(content,medium,dateTime)
    message = self.messages.build(content:content,medium:medium,status:Message::PENDING,scheduled_at:dateTime)
    message.save
    return message
  end
  
  def self.participantWithEmail(email)
    return Participant.find_by_email(Participant.formatEmail(email))
  end

  def self.participantWithPhone(phone)
    return Participant.find_by_phone(Participant.formatPhone(phone))
  end
        
  before_save { |participant| [participant.email = Participant.formatEmail(email), participant.phone =Participant.formatPhone(phone)] }
 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  VALID_PHONE_REGEX = /^[\(\)0-9\- \+\.]{10,20}$/ 
  validates :phone, presence: true,
                    format: { with: VALID_PHONE_REGEX, message: "must be a valid phone number"}
  
  default_scope order: 'participants.created_at DESC'   
                   
  protected
  def self.formatPhone(phone)
    return phone.gsub(/\D/, '')
  end
  
  def self.formatEmail(email)
    return email.downcase
  end
    
end
