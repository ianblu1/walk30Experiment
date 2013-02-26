require "CSV"

namespace :extract do
  desc "Extract data from database"
  
  task adaptive_strategy: :environment do
    csv_file=CSV.open('adaptiveStrategyData.csv', 'w')
    header = ['day1', 'day2', 'day3', 'day4', 'day5', 'day6', 'day7']
    #header = ['day1', 'day2', 'day3', 'day4', 'day5', 'day6']
    csv_file<<header
    nPerson=1
    Participant.find_all_by_status(1).each do |participant|
      p nPerson
      project_messages_count=participant.project_messages.count
      if project_messages_count<header.length
        next
      end
#      messages=participant.project_messages
#      #print messages
#      flags=0
#      messages.slice(2,header.length-1).each do |message|
#        if (message.flag==1) || (message.flag==2)
#          flags+=1
#        end
#      end
#      if flags<2
#        next
#      end
      
      numMessages=0
      response=[]
      participant.project_messages.each do |message|
        numMessages+=1
        if numMessages>header.length
          break
        end
        if message.flag==1
          response<<1
        else
          response<<0
        end
        
      end
      csv_file<<response
      
      nPerson+=1
    end
    
    csv_file.close_write
  end
  
  
end