class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy

  accepts_nested_attributes_for :invoice_items

  def subtotal
    invoice_items.sum(&:amount)
  end

  def tax
    subtotal * 0.16
  end

  def total
    subtotal + tax
  end

  def additional_tax_needed?
    invoice_items.any?(&:high_tax?)
  end
end