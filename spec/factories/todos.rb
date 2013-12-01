# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :todo do
    name { Faker::Lorem.sentence(6) }
    completed false
    due_date Date.today
    user

    factory :completed_todo do
      completed true
    end

    factory :overdue_todo do
      due_date 1.days.ago
    end
  end
end
