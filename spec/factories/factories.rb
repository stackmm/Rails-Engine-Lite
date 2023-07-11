FactoryBot.define do
  factory :merchant do
    name { Faker::Commerce.brand }
  end

  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end

  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Commerce.price(range: 0..100.0) }
    merchant
  end

  factory :invoice do
    status { ["shipped", "packaged", "returned"].sample }
    customer
    merchant
  end

  factory :invoice_item do
    quantity { Faker::Number.between(from: 1, to: 50) }
    unit_price { Faker::Commerce.price(range: 0..1000.0) }
    item
    invoice
  end

  factory :transaction do
    credit_card_number { Faker::Finance.credit_card }
    credit_card_expiration_date { Faker::Business.credit_card_expiry_date }
    result { ["success", "failed"].sample }
    invoice
  end
end