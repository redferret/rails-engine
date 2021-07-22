class Api::V1::Items::RevenueController < Api::V1::ApplicationController
  def index
    quantity = params[:quantity]
    if quantity && quantity.to_i != 0
      @items = Item.items_revenue_desc_order(quantity.to_i)
      render json: @items, each_serializer: ItemRevenueSerializer, status: :ok
    else
      render json: { error: 'Missing or invalid query paramter for quantity' }, status: :bad_request
    end
  end
end
