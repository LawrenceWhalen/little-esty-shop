require 'rails_helper'

RSpec.describe 'bulk discount admin revenue' do
  before :each do
    allow(GithubService).to receive(:contributors_info).and_return([
      {id: 26797256, login: 'Molly', contributions: 7},
      {id: 78388882, login: 'Sa', contributions: 80}
    ])
    allow(GithubService).to receive(:closed_pulls).and_return([
      {id: '0101010011', name: 'Molly', merged_at: 7},
      {id: '01011230011', name: 'Sa',merged_at: 80},
      {id: '01011230011', name: 'Sa', merged_at: nil}
    ])
    allow(GithubService).to receive(:repo_info).and_return({
        name: 'little-esty-shop'
    })
    allow(NagerService).to receive(:upcoming_holidays).and_return([
      {name: 'Labor Day', date: '2021-07-05'},
      {name: 'Columbus Day', date: '2021-09-06'},
      {name: 'Veterans day', date: '2021-10-11'},
      {name: 'Coding Day', date: '2021-12-12'}])

    @merchant_1 = Merchant.create!(name: 'Schroeder-Jerde')
    @merchant_2 = Merchant.create!(name: 'Schroeder-Jerde')
    @merchant_3 = Merchant.create!(name: 'Schroeder-Jerde')
    @merchant_4 = Merchant.create!(name: 'Schroeder-Jerde')
    @customer_2 = Customer.create!(first_name: 'Evan', last_name: 'East')
    @customer_3 = Customer.create!(first_name: 'Yasha', last_name: 'West')
    @customer_1 = Customer.create!(first_name: 'Sally', last_name: 'Shopper')
    @customer_4 = Customer.create!(first_name: 'Du', last_name: 'North')
    @customer_5 = Customer.create!(first_name: 'Polly', last_name: 'South')
    @customer_6 = Customer.create!(first_name: 'Sue', last_name: 'Ann')
    @item_1 = @merchant_1.items.create!(name: 'Gold Ring', description: 'Jewelery', unit_price: 10000)
    @item_2 = @merchant_2.items.create!(name: 'Hair Clip', description: 'Accessories', unit_price: 200)
    @item_3 = @merchant_3.items.create!(name: 'Silver Ring', description: 'Jewelery', unit_price: 5000)
    @item_4 = @merchant_4.items.create!(name: 'Hoop Earrings', description: 'Jewelery', unit_price: 1000)
    @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: "2012-03-06 14:54:15 UTC")
    @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, status: 1, unit_price: 11000, quantity: 10)
    @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, status: 1, unit_price: 5000, quantity: 5)
    @invoice_item_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_1.id, status: 1, unit_price: 1200, quantity: 15)
    @invoice_item_4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_1.id, status: 1, unit_price: 15000, quantity: 2)
    @bulk_discount_1 = @merchant_1.bulk_discounts.create!(percentage: 0.1, quantity_threshold: 10)
    @bulk_discount_2 = @merchant_2.bulk_discounts.create!(percentage: 0.2, quantity_threshold: 4)
    @bulk_discount_3 = @merchant_3.bulk_discounts.create!(percentage: 0.15, quantity_threshold: 10)
    @bulk_discount_4 = @merchant_4.bulk_discounts.create!(percentage: 0.18, quantity_threshold: 1)
  end

  describe 'total discounted price' do
    it 'shows the price with qualifying discounts applied' do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content('$1,589.00')
    end
  end
end
