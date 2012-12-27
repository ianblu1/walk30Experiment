namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_robot_participants
    make_amory_participant
    make_ian_participant
  end
  task seed: :environment do
    make_users
  end 
  task defineStrategies: :environment do
    make_strategies
  end 
  
end

def make_robot_participants
  10.times do |n|
    email = "robot-#{n+1}@example.com"
    phone = (9876543210+n).to_s
    age  = Random.rand(18..75)
    RobotParticipant.create!(email:    email,
                 		phone: 	  phone,
                 		is_male: [true, false].sample,
                 		age: age,
                 		zip_code: '90210')
  end
end



def make_ian_participant
  Participant.create!(email:    'ianblu1@gmail.com',
               		phone: 	  '6507048903',
               		is_male: true,
               		age: 150,
               		morning_reminder: true,
               		time_zone: "PST",
               		zip_code: '90210')  
end

def make_amory_participant
  Participant.create!(email:    'amory.schlender@gmail.com',
               		phone: 	  '5038050409',
               		is_male: true,
               		age: 88,
               		morning_reminder: false,
               		time_zone: "PST",
               		zip_code: '90210')  
end

def make_users
	admin1=User.create!(email:    "ianblu1@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    admin1.toggle!(:admin)
    admin2=User.create!(email:    "amory.schlender@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar")
	admin2.toggle!(:admin)

end


def make_strategies
  strategies=[[true, "7:30"], [true, "10:00"], [true, "11:45"],
    [false, "12:30"], [false, "14:00"], [false, "16:00"]]
  strategies.each do |strategy|
    Strategy.create!(morning: strategy[0], time: strategy[1])
  end
end