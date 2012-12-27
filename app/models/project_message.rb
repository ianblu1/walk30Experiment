class ProjectMessage < Message
  has_one :message_strategy
  has_one :strategy, :through => :message_strategy
      
end