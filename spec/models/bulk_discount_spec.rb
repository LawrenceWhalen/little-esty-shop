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
end
