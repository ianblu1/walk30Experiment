class DailyReminderStrategy 
  
  MESSAGE_TYPE = DailyReminderMessage
  
  def self.reminderMessages(participant=nil)
    if participant
      participant.messages.where(:type => ["ProjectMessage","DailyReminderMessage"])
    else
      Message.where(:type => ["ProjectMessage","DailyReminderMessage"])
    end
  end
  
  def self.deliveredReminderMessages(participant=nil)
    self.reminderMessages(participant).where(status:Message::DELIVERED)
  end
    
  def self.pendingReminderMessages(participant=nil)
    self.reminderMessages(participant).where(status:Message::PENDING)    
  end
  
  def self.cancelPedingReminderMessages(participant=nil)
    self.pendingReminderMessages(participant).each do |m|
      m.cancel
      m.save
    end
  end
    
  def self.nextReminderDateTime(participant)
    nextMessageDateTimeString = DateTime.tomorrow + " 12:00 " + participant.time_zone
    DateTime.strptime(nextMessageDateTimeString, '%Y-%m-%d %k:%M %Z')
  end
  
  def self.nextReminderContent(participant)
    "Walk30!\nReply \"yes\" if now is a good time for your daily reminder. Reply \"no\" if it isn't.\nReply \"walk\" when you go for your walk."
  end
  
  def self.nextReminderMessage(participant)
    participant.messages.build(type:MESSAGE_TYPE.name,medium:Message::TEXT,status:Message::PENDING,
                                    content:self.nextReminderContent(participant),
                                    scheduled_at:self.nextReminderDateTime(participant))
  end
  
end





