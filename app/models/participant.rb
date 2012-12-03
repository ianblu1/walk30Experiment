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
  attr_accessible :age, :email, :is_male, :phone, :zip_code, :status
  has_many :messages  
  
  def testMessageWithDelayInMinutes(content,delay)
    time = DateTime.now() + delay/24/60
    pendingMessageWithTime(content,Message::TEST,time)
    return 
  end
        
  def sendMessage(content,medium)
    message = self.messages.build(content:content,medium:medium,status:Message::PENDING,scheduled_at:DateTime.now)
    message.save
    return message.send()
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
