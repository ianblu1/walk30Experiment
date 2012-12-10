namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_participants
    make_amory_participant
    make_ian_participant
  end
  task seed: :environment do
    make_users
  end  
  
end

def make_participants
  100.times do |n|
    email = "example-#{n+1}@example.com"
    phone = (9876543210+n).to_s
    age  = Random.rand(18..75)
    Participant.create!(email:    email,
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
               		zip_code: '90210')  
end

def make_amory_participant
  Participant.create!(email:    'amory.schlender@gmail.com',
               		phone: 	  '5038050409',
               		is_male: true,
               		age: 88,
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