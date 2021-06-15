require 'rails_helper'

RSpec.describe 'The merchant items index' do
  before :each do
    allow(GithubService).to receive(:contributors_info).and_return([
      {id: 26797256, name: 'Molly', contributions: 7},
      {id: 78388882, name: 'Sa', contributions: 80}
    ])
    allow(GithubService).to receive(:closed_pulls).and_return([
      {id: 0101010011, name: 'Molly', merged_at: 7},
      {id: 01011230011, name: 'Sa',merged_at: 80},
      {id: 01011230011, name: 'Sa', merged_at: nil}
    ])
    allow(GithubService).to receive(:repo_info).and_return({
        name: 'little-esty-shop'
    })
    @merchant = FactoryBot.create(:merchant_with_items)
    @customer = FactoryBot.create(:customer)

    @item_1 = @merchant.items.first
    @item_2 = @merchant.items.create!(name: 'Bouquet of roses', description: '12 red roses', unit_price: '1900', enabled: true)
    @item_3 = @merchant.items.create!(name: 'Orchid', description: 'Purple, 3 inches', unit_price: '2700', enabled: false)
    @item_4 = @merchant.items.create!(name: 'Echevaria', description: 'Peacock varietal', unit_price: '3100', enabled: true)
    @item_5 = @merchant.items.create!(name: 'Fourth item', description: '4th best', unit_price: '26400', enabled: true)
    @item_6 = @merchant.items.create!(name: 'Fifth item', description: '5th best', unit_price: '2400', enabled: true)
    @item_7 = @merchant.items.create!(name: 'Sixth item', description: '6th best', unit_price: '50', enabled: true)

    @invoice_1 = @customer.invoices.create!(status: 1, updated_at: Date.parse("2021-03-01")) # is successful and paid
    @invoice_2 = @customer.invoices.create!(status: 0, updated_at: Date.parse("2021-03-01")) # is cancelled
    @invoice_3 = @customer.invoices.create!(status: 2, updated_at: Date.parse("2021-03-01")) # is still in progress, no good transactions
    @invoice_4 = @customer.invoices.create!(status: 1, updated_at: Date.parse("2021-02-08")) # is successful and paid
    @invoice_5 = @customer.invoices.create!(status: 1, updated_at: Date.parse("2021-02-01")) # has no successful transaction

    @invoice_item_1 = @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 2, unit_price: 5000, status: 0) # $10.00
    @invoice_item_2 = @item_2.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 2, unit_price: 2500, status: 0) # $50.00
    @invoice_item_3 = @item_4.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 2, unit_price: 1000, status: 0) # $20.00
    @invoice_item_4 = @item_1.invoice_items.create!(invoice_id: @invoice_2.id, quantity: 2, unit_price: 5000, status: 0) # $0.00
    @invoice_item_5 = @item_1.invoice_items.create!(invoice_id: @invoice_3.id, quantity: 2, unit_price: 5000, status: 0) # $0.00
    @invoice_item_6 = @item_5.invoice_items.create!(invoice_id: @invoice_4.id, quantity: 2, unit_price: 500, status: 0) # $10.00
    @invoice_item_7 = @item_6.invoice_items.create!(invoice_id: @invoice_4.id, quantity: 2, unit_price: 200, status: 0) # $4.00
    @invoice_item_8 = @item_7.invoice_items.create!(invoice_id: @invoice_4.id, quantity: 2, unit_price: 50, status: 0) # $1.00

    @invoice_1.transactions.create!(result: 1, credit_card_number: '534', credit_card_expiration_date: 'null')
    @invoice_2.transactions.create!(result: 1, credit_card_number: '534', credit_card_expiration_date: 'null')
    @invoice_4.transactions.create!(result: 1, credit_card_number: '534', credit_card_expiration_date: 'null')
    @invoice_5.transactions.create!(result: 0, credit_card_number: '534', credit_card_expiration_date: 'null')

    visit "/merchants/#{@merchant.id}/items"
  end

  it 'lists all of the items' do
    expect(page).to have_content @item_1.name
    expect(page).to have_content @item_2.name
    expect(page).to have_content @item_3.name
    expect(page).to have_content @item_4.name
  end

  it 'links to each item show page' do
    within "section#enabled" do
      click_on "#{@item_1.name}"
    end

    expect(current_path).to eq "/merchants/#{@merchant.id}/items/#{@item_1.id}"
    expect(page).to have_content @item_1.name
  end

  it 'groups items by status' do
    within "section#enabled" do
      expect(page).to have_content 'Enabled Items'
      expect(page).to have_content @item_1.name
      expect(page).to have_content @item_2.name
      expect(page).to have_content @item_4.name
      expect(page).to have_button 'Disable'
      expect(page).to_not have_button 'Enable'
      expect(page).to_not have_content @item_3.name
    end

    within "section#disabled" do
      expect(page).to have_content 'Disabled Items'
      expect(page).to have_content @item_3.name
      expect(page).to have_button 'Enable'
      expect(page).to_not have_button 'Disable'
      expect(page).to_not have_content @item_1.name
    end
  end

  it 'can enable a disabled item' do
    within "section#enabled" do
      within "div#item-#{@item_2.id}" do
        click_on 'Disable'
      end
    end

    expect(current_path).to eq "/merchants/#{@merchant.id}/items"

    within "section#enabled" do
      expect(page).to_not have_content @item_2.name
    end

    within "section#disabled" do
      expect(page).to have_content @item_2.name
    end
  end

  it 'can disable an enabled item' do
    within "section#disabled" do
      within "div#item-#{@item_3.id}" do
        click_on 'Enable'
      end
    end

    expect(current_path).to eq "/merchants/#{@merchant.id}/items"

    within "section#enabled" do
      expect(page).to have_content @item_3.name
    end

    within "section#disabled" do
      expect(page).to_not have_content @item_3.name
    end
  end

  it 'has a link to create a new item' do
    click_link 'New item'

    expect(current_path).to eq "/merchants/#{@merchant.id}/items/new"
  end

  it 'lists the top 5 best-selling items by revenue generated' do
    within "section#popular" do
      expect(@item_1.name).to appear_before @item_2.name
      expect(@item_2.name).to appear_before @item_4.name
      expect(@item_4.name).to appear_before @item_5.name
      expect(@item_5.name).to appear_before @item_6.name
      expect(page).to_not have_content @item_3.name
      expect(page).to_not have_content @item_7.name
    end
  end

  it 'links to each merchant item show page from popular items' do
    within "section#popular" do
      click_link "#{@item_1.name}"
    end

    expect(current_path).to eq "/merchants/#{@merchant.id}/items/#{@item_1.id}"
  end

  it 'displays the total revenue generated for each popular item' do
    within "section#popular" do
      within "li#item-#{@item_1.id}" do
        expect(page).to have_content 'Total revenue: $100.00'
      end
      within "li#item-#{@item_2.id}" do
        expect(page).to have_content 'Total revenue: $50.00'
      end
      within "li#item-#{@item_4.id}" do
        expect(page).to have_content 'Total revenue: $20.00'
      end
      within "li#item-#{@item_5.id}" do
        expect(page).to have_content 'Total revenue: $10.00'
      end
      within "li#item-#{@item_6.id}" do
        expect(page).to have_content 'Total revenue: $4.00'
      end
    end
  end

  it 'lists the top selling (invoice) date for each item' do

    within "section#popular" do
      within "li#item-#{@item_1.id}" do
        expect(page).to have_content 'Best revenue day: Monday, March 01, 2021'
      end
      within "li#item-#{@item_2.id}" do
        expect(page).to have_content 'Best revenue day: Monday, March 01, 2021'
      end
      within "li#item-#{@item_4.id}" do
        expect(page).to have_content 'Best revenue day: Monday, March 01, 2021'
      end
      within "li#item-#{@item_5.id}" do
        expect(page).to have_content 'Best revenue day: Monday, February 08, 2021'
      end
      within "li#item-#{@item_6.id}" do
        expect(page).to have_content 'Best revenue day: Monday, February 08, 2021'
      end
    end
  end
end
