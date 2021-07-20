class Api::V1::Items::ItemMerchantController < Api::V1::ApplicationController
  def show
    @item = Item.find(params[:item_id])
    @merchant = @item.merchant
    render json: @merchant, status: :ok
  rescue StandardError
    render json: { error: 'Resource not found', messages: ["Couldn't find Item with id #{params[:item_id]}"] },
           status: :not_found
  end
end
