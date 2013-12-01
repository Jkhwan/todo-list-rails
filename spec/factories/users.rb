# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    password "lighthouselabs"
    password_confirmation "lighthouselabs"
  end
end
