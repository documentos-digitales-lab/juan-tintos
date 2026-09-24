class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  validates :quantity, numericality: { greater_than: 0 }
  validates :product, presence: true
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

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