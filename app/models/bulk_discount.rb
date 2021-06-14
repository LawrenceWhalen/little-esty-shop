class BulkDiscount < ApplicationRecord

  belongs_to :merchant

  validates :quantity_threshold, presence: true, numericality: { only_integer: true }
  validates :percentage, presence: true, numericality: true

end
