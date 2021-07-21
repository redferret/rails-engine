class Api::V1::Merchants::ItemsController < Api::V1::ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
    render json: @items, status: :ok
  rescue StandardError
    render json: { error: 'Resource not found', messages: ["Couldn't find Merchant with id #{params[:merchant_id]}"] },
           status: :not_found
  end
end
