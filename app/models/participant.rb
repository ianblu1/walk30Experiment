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
  attr_accessible :age, :email, :is_male, :phone, :zip_code, :status, :morning_reminder, :walked_last_week, :time_zone
  attr_accessible :reminder_strategy
  has_many :messages, :dependent => :destroy
  has_many :project_messages, :dependent => :destroy  

  default_scope order: 'participants.created_at DESC'
  
  ReceivedMessageHandlers = WalkReceivedAutoreply, ReceivedMessageAutoflag
  
  #Status values
  PENDING = 0
  ACTIVE = 1
  TERMINATED = 2
 
  #message status codes
  MESSAGE_PENDING = 0
     
  WELCOME_MESSAGE_CONTENT="Welcome to The Walk30 Project!\nWe'll send you a daily reminder to go for a walk. Reply \"quit\" to opt out..."
  DISCLAIMER_MESSAGE_CONTENT="Walk30: Message & data rates from your carrier may apply."
  
  before_save {|participant|
    participant.email=Participant.formatEmail(email)
    participant.phone=Participant.formatPhone(phone)
    participant.status ||= 0
  }
     
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  VALID_PHONE_REGEX = /^[\(\)0-9\- \+\.]{10,20}$/ 
  validates :phone, presence: true,
                    format: { with: VALID_PHONE_REGEX, message: "must be a valid phone number"}
  
  validates :zip_code, presence: true
  
  validates :time_zone, presence: true,
                        inclusion: {in: %w(PST EST CST MST AKST HAST NST), message: "Sorry, we currently support only North American Time Zones"}


  def time_zone_long
    case self.time_zone
    when "PST"
      "Pacific Time (US & Canada)"
    when "AKST"
      "Alaska"
    when "EST"
      "Eastern Time (US & Canada)" 
    when "CST"
      "Central Time (US & Canada)" 
    when "HST"
      "Hawaii"
    when "MST"
      "Mountain Time (US & Canada)"
    end
  end
    
#  def time_zone 
#    ActiveSupport::TimeZone.find_by_zipcode(self.zip_code)
#  end
                      
  
  def self.withPhone(phone)
    return Participant.find_by_phone(Participant.formatPhone(phone))
  end
    
  #Daily reminder stuff
  
      
  def reminderStrategyClass
    eval(self.reminder_strategy.camelize)
  end
  
  def setNextReminderMessage
    if not self.pendingReminderMessages?
      m = self.reminderStrategyClass.nextReminderMessage(self)
      m.save
    end
  end
  
  def pendingReminderMessages?
    self.reminderStrategyClass.pendingReminderMessages(self).length>0
  end
      
  def messagesUnflaggedOrChangedWithinNSeconds(n)
    return self.messages.select {|message| not message.flagged? or message.secondsSinceLastUpdate < n}    
  end
  
  #Setting and querying participant status
    
  def activate
    if true #self.pending?
      self.status = ACTIVE
      self.experiment_begun_at = DateTime.now()
      self.save
      #Send the welcome message
      begin
        self.deliverMessage(WELCOME_MESSAGE_CONTENT,Message::TEXT)
        self.deliverMessage(DISCLAIMER_MESSAGE_CONTENT,Message::TEXT)
      rescue
        return false
      end
      return true
    end
  end
  
  def reactivate
    self.status = ACTIVE
    self.experiment_ended_at = nil
    self.save
  end
  
  def terminate
    self.status = TERMINATED
    self.experiment_ended_at = DateTime.now()
    self.save
  end
  
  def pending?
    self.status==PENDING
  end
  
  def active? 
    self.status==ACTIVE
  end

  def terminated? 
    self.status==TERMINATED
  end
  
  def days_active
    if self.experiment_begun_at
      if self.experiment_ended_at
        return (self.experiment_ended_at.to_f - self.experiment_begun_at.to_f)/86400.0
      else
        return (DateTime.now.to_f - self.experiment_begun_at.to_f)/86400.0
      end
    end
  end
    
  def days_terminated
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
  
  def days_in_status
    if self.pending?
      return self.days_pending
    elsif self.active?
      return self.days_active
    elsif self.terminated?
      return self.days_terminated
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
  
  #Message handling
  
  def deliverMessage(content,medium)
    message = self.messages.build(content:content,medium:medium,status:Message::PENDING)
    message.save
    message.deliver
  end
  
  def receiveMessage(content,medium)
    message = self.messages.build(content:content,medium:medium,status:Message::RECEIVED)
    message.save
    ReceivedMessageHandlers.each do |h| 
      h.respondToMessage(message)
    end
    return message
  end

  def messageDelivered(message)
    return message
  end

                     
  protected
  def self.formatPhone(phone)
    return phone.gsub(/\D/, '')
  end
  
  def self.formatEmail(email)
    return email.downcase
  end
    
end
