desc "This task is called by the Heroku scheduler add-on"
task :send_messages => :environment do
  Message.deliverAllPendingScheduledBeforeNow
end

task :schedule_next_reminder => :environment do
  DailyReminderMessage.find_all_by_status(Message::DELIVERED).each {|m| m.autoflag}
  Participant.find_all_by_status(Participant::ACTIVE).each {|p| p.setNextReminderMessage}
end
