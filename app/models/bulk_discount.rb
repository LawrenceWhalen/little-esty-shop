class BulkDiscount < ApplicationRecord

  belongs_to :merchant

  validates :quantity_threshold, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 9999999 }
  validates :percentage, presence: true, numericality: { greater_than_or_equal_to: 0.01, less_than_or_equal_to: 0.99 }

end
