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

      it 'returns an error hash if api limit exceeded' do
        allow(GithubService).to receive(:contributors_info).and_return(
          {
          :message=>"API rate limit exceeded for 98.38.149.214. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)",
          :documentation_url=>"https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting"}
        )

        expect(GithubContributors.contributors_info[0][1][:name]).to eq("Unavailable: API rate limit exceeded.")
        expect(GithubContributors.contributors_info[0][1][:contributions]).to eq("Unavailable: API rate limit exceeded.")
      end
    end
  end
end
