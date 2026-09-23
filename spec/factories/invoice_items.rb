FactoryBot.define do
  factory :invoice_item do
    invoice { nil }
    quantity { 1 }
    product { "MyString" }
    unit_price { "9.99" }
  end
end
