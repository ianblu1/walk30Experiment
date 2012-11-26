# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  age        :integer
#  zip_code   :string(255)
#  is_male    :boolean
#  phone      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  , participant.phone =phone.gsub(/\D/, '')

class Participant < ActiveRecord::Base
  attr_accessible :age, :email, :is_male, :phone, :zip_code
  
  before_save { |participant| [participant.email = email.downcase, participant.phone =phone.gsub(/\D/, '')] }
 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  VALID_PHONE_REGEX = /^[\(\)0-9\- \+\.]{10,20}$/ 
  validates :phone, presence: true,
                    format: { with: VALID_PHONE_REGEX, message: "must be a valid phone number"}
  
  default_scope order: 'participants.created_at DESC'                 
  
end
