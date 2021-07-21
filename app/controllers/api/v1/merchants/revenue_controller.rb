class Api::V1::Merchants::RevenueController < Api::V1::ApplicationController
  def index
    quantity = params[:quantity]
    if quantity && quantity.to_i != 0
      @merchants = Merchant.total_revenue_by_descending_order(quantity.to_i)
      render json: @merchants, status: :ok
    else
      render json: { error: 'Missing or invalid query paramter for quantity' }, status: :bad_request
    end
  end
end
