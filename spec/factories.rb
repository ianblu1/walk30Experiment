FactoryGirl.define do
  factory :participant do
    sequence(:email) { |n| "person_#{n}@example.com"}   
    sequence(:is_male) { true }   
    sequence(:phone) { "987-654-3210"}   
    sequence(:age) { |n| 30}   
    sequence(:zip_code) { 90210}   

    factory :admin do
      admin true
    end
  end

  factory :mesage do
    content "Lorem ipsum"
  end
end