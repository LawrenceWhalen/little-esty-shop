require 'rails_helper'

RSpec.describe 'bulk discount edit' do
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

  describe 'edit proccess' do
    describe 'bulk discount show page has an edit button' do
      it 'has a button to create a new bulk discount' do
        visit("/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk_discount_1.id}")

        expect(page).to have_button('Edit Discount')
      end
    end

    describe 'visit edit page' do
      it 'is prefilled with the current values' do
        visit("/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk_discount_1.id}")

        click_button('Edit Discount')

        expect(find_field('Quantity threshold').value).to eq('10')
        expect(find_field('Percentage').value).to eq('90')
      end
    end

    describe 'editing the form' do
      it 'is prefilled with the current values' do
        visit("/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk_discount_1.id}")

        click_button('Edit Discount')

        fill_in('Quantity threshold', with: 16)
        fill_in('Percentage', with: 83)

        click_button('Update Discount')

        expect(page).to have_current_path("/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk_discount_1.id}")
        within('div#bulk') do
          expect(page).to have_content('16')
          expect(page).to have_content('83')
          expect(page).to_not have_content('10')
          expect(page).to_not have_content('90')
        end
      end
    end
  end
end
