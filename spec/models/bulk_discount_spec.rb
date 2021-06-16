require 'rails_helper'

RSpec.describe BulkDiscount do

  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity_threshold) }
    it { should validate_numericality_of(:quantity_threshold).only_integer.is_less_than_or_equal_to(9999999).is_greater_than_or_equal_to(1) }
    it { should validate_presence_of(:percentage) }
    it { should validate_numericality_of(:percentage).is_less_than_or_equal_to(0.99).is_greater_than_or_equal_to(0.01) }
  end

  describe 'class methods' do
    describe '#find_max' do
      it 'returns the bulk discount with the highest discount for that quantity' do
        @merchant = Merchant.create!(name: 'Schroeder-Jerde')
        @customer_1 = Customer.create!(first_name: 'Evan', last_name: 'East')
        @item_1 = @merchant.items.create!(name: 'Gold Ring', description: 'Jewelery', unit_price: 10000)
        @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: "2012-03-06 14:54:15 UTC")
        @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, status: 1, unit_price: 11000, quantity: 10)
        @bulk_discount_1 = @merchant.bulk_discounts.create!(percentage: 0.1, quantity_threshold: 10)
        @bulk_discount_2 = @merchant.bulk_discounts.create!(percentage: 0.15, quantity_threshold: 15)
        @bulk_discount_3 = @merchant.bulk_discounts.create!(percentage: 0.09, quantity_threshold: 9)

        expect(BulkDiscount.find_max(@merchant.id, @invoice_item_1.quantity)[0].percentage).to eq(@bulk_discount_1.percentage)
      end
    end
  end
end
