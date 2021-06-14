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

  def total_revenue_for_merchant(merchant_id)
    items
    .where(merchant_id: merchant_id)
    .sum('invoice_items.unit_price * invoice_items.quantity')
  end
end
