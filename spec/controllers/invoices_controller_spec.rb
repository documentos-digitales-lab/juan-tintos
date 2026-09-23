require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  describe 'POST #create' do
    let!(:customer) { Customer.create!(rfc: 'AAA') }

    let(:valid_params) do
      {
        customer_id: customer.id,
        invoice: {
          invoice_items_attributes: {
            '0' => {
              quantity: 2,
              product: 'Product 1',
              unit_price: '100.00'
            },
            '1' => {
              quantity: 3,
              product: 'Product 2',
              unit_price: '50.00'
            }
          }
        }
      }
    end

    it 'creates an invoice with two items' do
      expect {
        post :create, params: valid_params
      }.to change(Invoice, :count).by(1)
        .and change(InvoiceItem, :count).by(2)

      expect(response).to redirect_to(new_invoice_path)

      invoice = Invoice.last
      expect(invoice.invoice_items.size).to eq(2)
      expect(invoice.subtotal).to eq(350.00)
      expect(invoice.tax).to eq(56.00)
      expect(invoice.total).to eq(406.00)
    end
  end
end
