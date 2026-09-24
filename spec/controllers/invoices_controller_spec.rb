require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  describe 'GET #new' do
    let!(:customer) { Customer.create!(rfc: 'AAA') }

    it 'renders the form with the greeting when the API succeeds' do
      allow(CustomerApi).to receive(:find).with(customer.id).and_return(
        { "firstName" => "James", "lastName" => "Davis" }
      )

      get :new, params: { customer_id: customer.id }

      expect(response).to render_template(:new)
      expect(assigns(:customer_data)).to eq({ "firstName" => "James", "lastName" => "Davis" })
    end

    it 'still renders the form when the API fails' do
      allow(CustomerApi).to receive(:find).and_raise("Customer API request failed")

      get :new, params: { customer_id: customer.id }

      expect(response).to render_template(:new)
      expect(assigns(:customer_data)).to be_nil
    end
  end

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

      expect(response).to redirect_to(
        new_invoice_path(customer_id: customer.id)
      )

      invoice = Invoice.last

      expect(invoice.invoice_items.size).to eq(2)
      expect(invoice.subtotal).to eq(350.00)
      expect(invoice.tax).to eq(56.00)
      expect(invoice.total).to eq(406.00)
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          customer_id: customer.id,
          invoice: {
            invoice_items_attributes: {
              '0' => { quantity: nil, product: '', unit_price: nil },
              '1' => { quantity: 3, product: 'Product 2', unit_price: '50.00' }
            }
          }
        }
      end

      it 'does not create an invoice and re-renders the form' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Invoice, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end
end