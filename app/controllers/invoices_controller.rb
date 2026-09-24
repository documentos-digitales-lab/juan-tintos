class InvoicesController < ApplicationController
  def new
    @customer = Customer.find(params[:customer_id])
    @customer_data = CustomerApi.find(@customer.id)
    @invoice = @customer.invoices.build
    2.times { @invoice.invoice_items.build }
  end

  def create
    customer = Customer.find(params[:customer_id])
    invoice = customer.invoices.create!(invoice_params)

    redirect_to new_invoice_path(customer_id: customer.id), notice: "Invoice created successfully."
  end

  private

  def invoice_params
    params.require(:invoice).permit(
      invoice_items_attributes: [:quantity, :product, :unit_price]
    )
  end
end