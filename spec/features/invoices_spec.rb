require "rails_helper"

RSpec.feature "Invoice creation" do
  scenario "a customer creates an invoice with two products" do
    customer = Customer.create!(rfc: "AAA")

    visit new_invoice_path(customer_id: customer.id)

    within("#invoice-item-1") do
      fill_in "Quantity", with: 2
      fill_in "Product / Service", with: "Product 1"
      fill_in "Unit Price", with: 100
    end

    within("#invoice-item-2") do
      fill_in "Quantity", with: 3
      fill_in "Product / Service", with: "Product 2"
      fill_in "Unit Price", with: 50
    end

    expect {
      click_on "Create"
    }.to change(Invoice, :count).by(1)
      .and change(InvoiceItem, :count).by(2)

    invoice = Invoice.last

    expect(invoice.customer).to eq(customer)
    expect(invoice.invoice_items.count).to eq(2)
    expect(invoice.subtotal).to eq(350.00)
    expect(invoice.tax).to eq(56.00)
    expect(invoice.total).to eq(406.00)
  end

  scenario "shows the customer's personalized greeting" do
    customer = Customer.create!(rfc: "AAA")

    allow(CustomerApi).to receive(:find)
      .with(customer.id)
      .and_return(
        {
          "firstName" => "James",
          "lastName" => "Davis"
        }
      )

    visit new_invoice_path(customer_id: customer.id)

    expect(page).to have_content("Hello James Davis!")
    expect(page).to have_content("Please add your products and click on Create:")
  end
end