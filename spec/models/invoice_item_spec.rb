require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
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
