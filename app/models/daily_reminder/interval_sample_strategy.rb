class IntervalSampleStrategy < DailyReminderStrategy
  
  Early = "10:00"
  Late = "16:00"
  
  def self.nextReminderDateTime(participant)
    Time.zone = "Pacific Time (US & Canada)" #used to make sure tomorrow is wrt admins
    earliest = DateTime.strptime(DateTime.tomorrow.to_s + " #{Early} " + participant.time_zone_long, '%Y-%m-%d %k:%M %Z')    
    latest = DateTime.strptime(DateTime.tomorrow.to_s + " #{Late} " + participant.time_zone_long, '%Y-%m-%d %k:%M %Z')    
    earliest + (latest - earliest)*rand
  end
    
end