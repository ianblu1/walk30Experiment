namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_participants
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

def make_users
	admin1=User.create!(email:    "ian@example.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    admin1.toggle!(:admin)
    admin2=User.create!(email:    "amory@example.com",
                 password: "foobar",
                 password_confirmation: "foobar")
	admin2.toggle!(:admin)

end