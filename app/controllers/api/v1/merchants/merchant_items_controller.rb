class Api::V1::Merchants::MerchantItemsController < Api::V1::ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
    render json: @items, status: :ok
  rescue StandardError
    render json: { error: 'Merchant not found' }, status: :not_found
  end
end
