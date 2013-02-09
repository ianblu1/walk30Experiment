class IntervalSampleStrategy < DailyReminderStrategy
  
  Early = "10:00"
  Late = "16:00"
  
  def self.nextReminderDateTime(participant)
    Time.zone = "Pacific Time (US & Canada)" #used to make sure tomorrow is wrt admins
    today = DateTime.now().strftime("%Y-%m-%d")
    earliest = DateTime.strptime(today + " #{Early} " + participant.time_zone_long, '%Y-%m-%d %k:%M %Z')    
    latest = DateTime.strptime(today + " #{Late} " + participant.time_zone_long, '%Y-%m-%d %k:%M %Z')    
    nextMessageDateTime = earliest + (latest - earliest)*rand
    while nextMessageDateTime < DateTime.now
      nextMessageDateTime = nextMessageDateTime.advance(:days => 1)
    end
    nextMessageDateTime
  end
    
end