class Invoice < ApplicationRecord
  enum status: [:in_progress, :completed, :cancelled]

  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions

  validates :customer_id, presence: true
  validates :status, {presence: true}
  validates_numericality_of :status

  def self.unshipped_items
    joins(:invoice_items)
    .where('invoice_items.status != 2')
    .select('invoices.*')
    .group('invoices.id')
    .order('invoices.created_at asc')
  end

  def item_sale_price
    items
    .select('items.*, invoice_items.unit_price as sale_price, invoice_items.quantity as sale_quantity')
  end

  def total_revenue
    invoice_items
    .sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def discounted_revenue
    tally = items
    .select('invoice_items.*, items.merchant_id')
    tally.sum do |invoice_item|
      merch = invoice_item.merchant_id
      quan = invoice_item.quantity
      discount = BulkDiscount.find_max(merch, quan)
      if discount == []
        discount = 1
      else
        discount = 1.0 - discount[0].percentage
      end
      invoice_item.quantity * invoice_item.unit_price * discount
    end
  end

  def total_revenue_for_merchant(merchant_id)
    items
    .where(merchant_id: merchant_id)
    .sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def discount_revenue_for_merchant(merchant_id)
    tally = items
    .where(merchant_id: merchant_id)
    .select('invoice_items.*, items.merchant_id')
    tally.sum do |invoice_item|
      merch = invoice_item.merchant_id
      quan = invoice_item.quantity
      discount = BulkDiscount.find_max(merch, quan)
      if discount == []
        discount = 1
      else
        discount = 1.0 - discount[0].percentage
      end
      invoice_item.quantity * invoice_item.unit_price * discount
    end
  end
end
