class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy

  accepts_nested_attributes_for :invoice_items

  validate :must_have_exactly_two_products

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

  private

  def must_have_exactly_two_products
    items = invoice_items.reject(&:marked_for_destruction?)

    return if items.size == 2

    errors.add(:invoice_items, "must contain exactly 2 products")
  end
end