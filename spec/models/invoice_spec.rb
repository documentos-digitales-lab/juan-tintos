require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe '#subtotal' do
    it 'calculates the sum of the item amounts' do
      invoice = Invoice.new

      invoice.invoice_items.build(quantity: 2, unit_price: 100.00)
      invoice.invoice_items.build(quantity: 3, unit_price: 50.00)

      expect(invoice.subtotal).to eq(350.00)
    end
  end

  describe '#tax' do
    it 'calculates 16 percent of the subtotal' do
      invoice = Invoice.new

      invoice.invoice_items.build(quantity: 2, unit_price: 100.00)
      invoice.invoice_items.build(quantity: 3, unit_price: 50.00)

      expect(invoice.tax).to eq(56.00)
    end
  end

  describe '#total' do
    it 'calculates subtotal plus tax' do
      invoice = Invoice.new

      invoice.invoice_items.build(quantity: 2, unit_price: 100.00)
      invoice.invoice_items.build(quantity: 3, unit_price: 50.00)

      expect(invoice.total).to eq(406.00)
    end
  end

  describe '#additional_tax_needed?' do
    it 'returns false when no item has high tax' do
      invoice = Invoice.new

      invoice.invoice_items.build(quantity: 1, unit_price: 100.00)
      invoice.invoice_items.build(quantity: 1, unit_price: 100.00)

      expect(invoice.additional_tax_needed?).to be false
    end

    it 'returns true when an item has high tax' do
      invoice = Invoice.new

      invoice.invoice_items.build(quantity: 1000, unit_price: 20.00)
      invoice.invoice_items.build(quantity: 1, unit_price: 100.00)

      expect(invoice.additional_tax_needed?).to be true
    end
  end
end
