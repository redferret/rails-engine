class Api::V1::Items::ItemMerchantController < Api::V1::ApplicationController
  def show
    @item = Item.find(params[:item_id])
    @merchant = @item.merchant
    render json: @merchant, status: :ok
  rescue StandardError
    render json: { messages: ['Count not find Item'] }, status: :not_found
  end
end
