class Api::V1::Merchants::GetMerchantController < Api::V1::ApplicationController
  def show
    begin
      @merchant = Merchant.find(params[:id])
      render json: @merchant, status: :ok
    rescue
      render json: @merchant, status: :not_found
    end
  end
end