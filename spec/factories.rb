FactoryGirl.define do
  factory :product do
    sequence :name do |n| 
      "pet turtle #{n}"
    end
    description "The best pet in the world."
    price 100
  end
end