require 'rails_helper'

RSpec.describe GithubService do
  describe 'class methods' do
    describe '#repo_info' do
      xit 'returns a collection of data for the repo' do
        actual = GithubService.repo_info

        expect(actual[:name]).to eq('little-esty-shop')
      end
    end

    describe '#contributors_info' do
      xit 'returns all contributors info' do
        actual = GithubService.contributors_info

        expect(actual[0][:login]).to eq('mkrumholz')
      end
    end
  end
end
