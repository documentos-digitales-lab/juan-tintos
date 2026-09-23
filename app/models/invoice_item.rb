class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  def amount
    quantity * unit_price
  end

  def tax
    amount * 0.16
  end

  def high_tax?
    tax > 2_000
  end
end