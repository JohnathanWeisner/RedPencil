# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :red_pencil_tag do
    product nil
    started_at DateTime.now
    ended_at nil
    starting_price 1
  end
end
