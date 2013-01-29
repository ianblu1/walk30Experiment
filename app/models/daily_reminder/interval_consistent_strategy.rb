class IntervalConsistentStrategy < DailyReminderStrategy
  
  def self.nextReminderDateTime(participant)
    previousReminders = self.deliveredReminderMessages(participant)
    if previousReminders.length > 0
      lastMessage = previousReminders.last
      nextMessageDateTime = lastMessage.scheduled_at
      while nextMessageDateTime < DateTime.now
        nextMessageDateTime += 24*60*60
      end
      nextMessageDateTime
    else
      #use the interval sample strategy to set the first reminder time
      IntervalSampleStrategy.nextReminderDateTime(participant)
    end
  end  
end

