class BulkDiscount < ApplicationRecord

  belongs_to :merchant

  validates :quantity_threshold, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 9999999 }
  validates :percentage, presence: true, numericality: { greater_than_or_equal_to: 0.01, less_than_or_equal_to: 0.99 }

  def self.find_max(merchant_id, quantity)
    select('bulk_discounts.*').where('bulk_discounts.merchant_id = ? and bulk_discounts.quantity_threshold <= ?', merchant_id, quantity).order(percentage: :desc).limit(1)
  end

end
