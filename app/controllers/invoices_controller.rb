class InvoicesController < ApplicationController
  def new
  end

  def create
    customer = Customer.find(params[:customer_id])
    invoice = customer.invoices.create!(invoice_params)

    redirect_to new_invoice_path, notice: "Invoice created successfully."
  end

  private

  def invoice_params
    params.require(:invoice).permit(
      invoice_items_attributes: [:quantity, :product, :unit_price]
    )
  end
end