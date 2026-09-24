require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:product) }

    it 'is invalid without a quantity' do
      item = InvoiceItem.new(product: 'Widget', unit_price: 10)
      expect(item).not_to be_valid
      expect(item.errors[:quantity]).to be_present
    end

    it 'is invalid with a quantity of zero or less' do
      item = InvoiceItem.new(product: 'Widget', quantity: 0, unit_price: 10)
      expect(item).not_to be_valid
    end

    it 'is invalid without a unit price' do
      item = InvoiceItem.new(product: 'Widget', quantity: 1)
      expect(item).not_to be_valid
      expect(item.errors[:unit_price]).to be_present
    end

    it 'is invalid with a unit price of zero or less' do
      item = InvoiceItem.new(product: 'Widget', quantity: 1, unit_price: 0)
      expect(item).not_to be_valid
    end

    it 'is valid with a product, positive quantity, and positive unit price' do
      invoice = Invoice.new
      item = invoice.invoice_items.build(product: 'Widget', quantity: 1, unit_price: 10)
      expect(item).to be_valid
    end
  end

  describe '#amount' do
    it 'calculates the amount from quantity and unit price' do
      item = InvoiceItem.new(quantity: 2, unit_price: 150.00)

      expect(item.amount).to eq(300.00)
    end
  end

  describe '#high_tax?' do
    it 'returns true when the tax exceeds 2000' do
      item = InvoiceItem.new(quantity: 1000, unit_price: 20.00)

      expect(item.high_tax?).to be true
    end

    it 'returns false when the tax does not exceed 2000' do
      item = InvoiceItem.new(quantity: 1, unit_price: 100.00)

      expect(item.high_tax?).to be false
    end
  end
end