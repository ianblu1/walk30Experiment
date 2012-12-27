class MessageStrategy < ActiveRecord::Base
  #attr_accessible :message_id, :strategy_id
  attr_accessible :strategy_id
  belongs_to :strategy
  belongs_to :project_message
end
