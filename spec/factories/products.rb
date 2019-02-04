FactoryBot.define do
  factory :product do
    name { Faker::Name.unique.name }
    stock { rand(10_000) }
    price { rand(10_000) }
  end
end
