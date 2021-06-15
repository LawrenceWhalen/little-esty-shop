require 'rails_helper'

RSpec.describe NagerService do
  describe 'class methods' do
    describe '#upcoming_holidays' do
      xit 'returns an array of upcoming holidays' do
        actual = NagerService.upcoming_holidays

        expect(actual.class).to eq(Array)
        expect(actual[0].keys.include?(:name)).to eq(true)
        expect(actual[0].keys.include?(:date)).to eq(true)
        expect(actual[0][:name].nil?).to eq(false)
        expect(actual[0][:date].nil?).to eq(false)
        expect(actual[0][:name].class).to eq(String)
        expect(actual[0][:date].class).to eq(String)
      end
    end
  end
end
