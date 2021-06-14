require 'rails_helper'

RSpec.describe 'bulk discount index' do
  describe 'merchant show' do
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

      @merchant_1 = Merchant.create!(name: "Ralph's Monkey Hut")
      @bulk_discount_1 = @merchant_1.bulk_discounts.create!(percentage: 0.9, quantity_threshold: 10)
      @bulk_discount_2 = @merchant_1.bulk_discounts.create!(percentage: 0.8, quantity_threshold: 30)
      @bulk_discount_3 = @merchant_1.bulk_discounts.create!(percentage: 0.75, quantity_threshold: 40)
      @bulk_discount_4 = @merchant_1.bulk_discounts.create!(percentage: 0.62, quantity_threshold: 50)
    end

    it 'has a link to bulk show page on merchant dashboard' do
      visit "/merchants/#{@merchant_1.id}/dashboard"

      expect(page).to have_button('Discounts')
      click_button('Discounts')

      expect(page).to have_current_path("/merchants/#{@merchant_1.id}/bulk_discounts")
    end

    it 'has the percentage and quantity threshold for each discount' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts"

      expect(page).to have_content('Percentage: 90%')
      expect(page).to have_content('Percentage: 80%')
      expect(page).to have_content('Percentage: 75%')
      expect(page).to have_content('Percentage: 62%')

      expect(page).to have_content('Threshold: 10 items')
      expect(page).to have_content('Threshold: 30 items')
      expect(page).to have_content('Threshold: 40 items')
      expect(page).to have_content('Threshold: 50 items')
    end

    it 'has the percentage and quantity threshold for each discount' do
      visit "/merchants/#{@merchant_1.id}/bulk_discounts"

      expect(page).to have_link("Discount #{@bulk_discount_1.id}:")
      expect(page).to have_link("Discount #{@bulk_discount_2.id}:")
      expect(page).to have_link("Discount #{@bulk_discount_3.id}:")
      expect(page).to have_link("Discount #{@bulk_discount_4.id}:")

      click_link("Discount #{@bulk_discount_1.id}:")

      expect(page).to have_current_path("/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk_discount_1.id}")
    end
  end
end
