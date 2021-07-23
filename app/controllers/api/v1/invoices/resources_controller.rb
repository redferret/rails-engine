class Api::V1::Invoices::ResourcesController < Api::V1::ApplicationController
  def index; end

  def show
    invoice = Invoice.find(params[:id])
    render json: invoice
  rescue StandardError
    render json: { error: 'Resource not found', messages: ["Couldn't find Invoice with id #{params[:id]}"] },
           status: :not_found
  end

  def create
    invoice = Invoice.new(invoice_params)
    invoice.status = :in_progress
    if invoice.save
      render json: invoice, status: :created
    else
      render json: { error: 'Resource not created', messages: invoice.errors.full_messages }, status: :bad_request
    end
  end

  def update; end

  def destroy; end

  private

  def invoice_params
    params.permit(:customer_id, :merchant_id)
  end
end
