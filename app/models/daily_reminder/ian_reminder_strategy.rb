class IanReminderStrategy < DailyReminderStrategy
  MESSAGE_TYPE = DailyReminderMessage
  
  AM_MESSAGE_TIMES = ["7:30","10:00","11:45"]
  PM_MESSAGE_TIMES = ["12:30","14:00","16:00"]
  
  def self.randomMessageTimeString(participant)
    if participant.morning_reminder?
      AM_MESSAGE_TIMES.sample
    else
      PM_MESSAGE_TIMES.sample
    end
  end
    
  def self.nextReminderDateTime(participant)
    Time.zone = "Pacific Time (US & Canada)"
    nextMessageDateTimeString = DateTime.tomorrow.to_s + " " + self.randomMessageTimeString(participant) + " " + participant.time_zone_long
    nextMessageDateTime = DateTime.strptime(nextMessageDateTimeString, '%Y-%m-%d %k:%M %Z')    
    previousReminders = self.deliveredReminderMessages(participant)
    if previousReminders.length > 0
      lastMessage = previousReminders.last
      if lastMessage.flagPositive?
        nextMessageDateTime = lastMessage.scheduled_at
      end
    end
    return nextMessageDateTime
  end
end

