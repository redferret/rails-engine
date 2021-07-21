FactoryBot.define do
  factory :invoice_item do
    quantity { rand(1..5) }
    unit_price { rand(4..75).to_f }
  end
end
