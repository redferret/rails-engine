class Api::V1::Merchants::GetMerchantController < Api::V1::ApplicationController
  def show
    @merchant = Merchant.find(params[:id])
    render json: @merchant, status: :ok
  rescue StandardError
    render json: { error: 'Merchant not found' }, status: :not_found
  end
end
