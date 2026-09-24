class InvoicesController < ApplicationController
  def new
    @customer = Customer.find(params[:customer_id])
    @customer_data = fetch_customer_data(@customer.id)
    @invoice = @customer.invoices.build
    2.times { @invoice.invoice_items.build }
  end

  def create
    @customer = Customer.find(params[:customer_id])
    @invoice = @customer.invoices.build(invoice_params)

    if @invoice.save
      redirect_to new_invoice_path(customer_id: @customer.id), notice: "Invoice created successfully."
    else
      @customer_data = fetch_customer_data(@customer.id)
      (2 - @invoice.invoice_items.size).times { @invoice.invoice_items.build }
      render :new, status: :unprocessable_entity
    end
  end

  private

  def fetch_customer_data(customer_id)
    CustomerApi.find(customer_id)
  rescue StandardError => e
    Rails.logger.warn("CustomerApi.find failed for customer #{customer_id}: #{e.message}")
    nil
  end

  def invoice_params
    params.require(:invoice).permit(
      invoice_items_attributes: [:quantity, :product, :unit_price]
    )
  end
end