FactoryBot.define do
  factory :item do
    sequence(:name) {|n| "Audrey #{n}"}
    sequence(:description) {|n| "Description #{n}"}
    sequence :unit_price do |n|
      1000 + (1000 * n)
    end
    merchant
    enabled { true }
  end
end
