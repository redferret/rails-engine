class Api::V1::Merchants::RevenueController < Api::V1::ApplicationController
  def index
    quantity = params[:quantity]
    if quantity && quantity.to_i != 0
      @merchants = Merchant.total_revenue_by_descending_order(quantity.to_i)
      render jsonapi: Merchant.total_revenue_by_descending_order(quantity.to_i)
    else
      render jsonapi: { errors: ['Missing or invalid query paramter for quantity'] }, status: :bad_request
    end
  end

  def show
    @merchant = Merchant.find(params[:id])
    @merchant_revenue = @merchant.total_revenue
    if @merchant_revenue
      render jsonapi: @merchant_revenue
    else
      render jsonapi: @merchant
    end
  rescue StandardError
    render jsonapi: { errors: ['Resource not found'] },
           status: :not_found
  end
end
