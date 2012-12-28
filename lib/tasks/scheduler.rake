desc "This task is called by the Heroku scheduler add-on"
task :send_messages => :environment do
  Message.deliverAllPendingScheduledBeforeNow
end
