module ApplicationHelper
  def invoice_enum_integer(invoice)
    enum_convert = Invoice.statuses
    enum_convert[invoice.status]
  end
end
