class Api::V1::Merchants::RevenueController < Api::V1::ApplicationController
  def index
    quantity = params[:quantity]
    if quantity && quantity.to_i != 0
      @merchants = Merchant.total_revenue_by_descending_order(quantity.to_i)
      render json: @merchants, each_serializer: MerchantRevenueSerializer, status: :ok
    else
      render json: { error: 'Missing or invalid query paramter for quantity' }, status: :bad_request
    end
  end

  def show
    @merchant = Merchant.find(params[:id])
    @merchant_revenue = @merchant.total_revenue
    if @merchant_revenue
      render json: @merchant_revenue, serializer: MerchantTotalRevenueSerializer, status: :ok
    else
      render json: @merchant, serializer: MerchantTotalRevenueSerializer, status: :ok
    end
  rescue StandardError
    render json: { error: 'Resource not found', messages: ["Merchant not found with id #{params[:id]}"] },
           status: :not_found
  end
end
