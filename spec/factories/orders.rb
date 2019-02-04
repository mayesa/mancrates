FactoryBot.define do
  factory :order do
    product
    customer_name { Faker::Name.unique.name }
    adress { Faker::Lorem.sentence }
    zip_code { Faker::Address.zip_code }
    shipping_method Order.shipping_methods.sample
    aasm_state :processing

    factory :awaiting_pickup_order do
      aasm_state :awaiting_pickup
      fedex_id { SecureRandom.uuid }
    end

    factory :in_transit_order do
      aasm_state :in_transit
      fedex_id { SecureRandom.uuid }
    end

    factory :out_for_delivery_order do
      aasm_state :out_for_delivery
      fedex_id { SecureRandom.uuid }
    end
  end
end
