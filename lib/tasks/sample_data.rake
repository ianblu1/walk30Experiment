namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_participants  
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