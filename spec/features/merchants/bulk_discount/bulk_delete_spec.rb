require 'rails_helper'

RSpec.describe 'bulk discount create' do
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

    @merchant_1 = Merchant.create!(name: "Ralph's Monkey Hut")
    @bulk_discount_1 = @merchant_1.bulk_discounts.create!(percentage: 0.9, quantity_threshold: 10)
    @bulk_discount_2 = @merchant_1.bulk_discounts.create!(percentage: 0.8, quantity_threshold: 30)
    @bulk_discount_3 = @merchant_1.bulk_discounts.create!(percentage: 0.75, quantity_threshold: 40)
    @bulk_discount_4 = @merchant_1.bulk_discounts.create!(percentage: 0.62, quantity_threshold: 50)
  end

  describe 'deletion proccess' do
    describe 'merchant bulk discount index delete' do
      it 'has a button to create a new bulk discount' do
        visit("/merchants/#{@merchant_1.id}/bulk_discounts")

        expect(page).to have_button('Delete Discount', count: 4)
      end
      it 'deletes the bulk discount when you delete the button' do
        visit("/merchants/#{@merchant_1.id}/bulk_discounts")

        within("li#bl-#{@bulk_discount_1.id}") do
          click_button 'Delete Discount'
        end

        expect(page).to have_button('Delete Discount', count: 3)
        expect(page).to_not have_content('Percentage: 90%')
        expect(page).to_not have_content('Threshold: 10 items')

        expect(page).to have_current_path("/merchants/#{@merchant_1.id}/bulk_discounts")
      end
    end
  end
end
