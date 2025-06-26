class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @invoices = Invoice.includes(:line_items).order(created_at: :desc)
  end

  def show
  end

  def new
    @invoice = Invoice.new
    @invoice.line_items.build
  end

  def create
    @invoice = current_user.invoices.build(invoice_params)

    if @invoice.save
      flash[:notice] = "Invoice was successfully created."
      redirect_to @invoice
    else
      flash.now[:alert] = "There was an error creating the invoice."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @invoice.line_items.build if @invoice.line_items.empty?
  end

  def update
    if @invoice.update(invoice_params)
      flash[:notice] = "Invoice was successfully updated."
      redirect_to @invoice
    else
      flash.now[:alert] = "There was an error updating the invoice."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @invoice.destroy
    flash[:notice] = "Invoice was successfully deleted."
    redirect_to invoices_path
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(
      line_items_attributes: [
        :id, :product_id, :quantity, :price, :_destroy
      ]
    )
  end
end
