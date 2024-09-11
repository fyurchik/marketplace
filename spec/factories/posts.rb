FactoryBot.define do
  factory :post do
    brand { "merc" }
    model { "glc" }
    body_type { "sedan" }
    mileage { 500200 }
    color { "Blue" }
    price { 15000 }
    fuel { "gas" }
    year { 2018 }
    engine_capacity { 1.84 }
    phone_number { "12312" }
    name { "yura" }
    user
  end
end
