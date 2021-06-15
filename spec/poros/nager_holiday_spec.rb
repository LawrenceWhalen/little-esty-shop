require 'rails_helper'

RSpec.describe NagerHolidays do
  describe 'instance methods' do
    describe '#three_holidays' do
      it 'returns an array of hashes with three upcoming holidays' do
        allow(NagerService).to receive(:upcoming_holidays).and_return([
          {
           name: 'Labor Day',
           date: '2021-07-05'
           },
          {
           name: 'First Peoples Day',
           date: '2021-09-06'
         },
         {
          name: 'Veterans day',
          date: '2021-10-11'
        },
         {
          name: 'Coding Day',
          date: '2021-12-12'
         }])

        expect(NagerHolidays.three_holidays[0][:name]).to eq('Labor Day')
        expect(NagerHolidays.three_holidays[2][:date]).to eq('2021-10-11')
        expect(NagerHolidays.three_holidays.length).to eq(3)
      end
    end

    describe 'errors from api limit' do
      it 'returns an error if the api limit is exceeded' do
        allow(NagerService).to receive(:upcoming_holidays).and_return([
          {
           message: 'error',
           name: 'Labor Day',
           date: '2021-07-05'
           },
          {
           name: 'First Peoples Day',
           date: '2021-09-06'
         },
         {
          name: 'Veterans day',
          date: '2021-10-11'
        },
         {
          name: 'Coding Day',
          date: '2021-12-12'
         }])

        expect(NagerHolidays.three_holidays).to eq("Unavailable: API rate limit exceeded.")
      end
    end
  end
end
