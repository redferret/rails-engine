class Api::V1::Merchants::SearchMerchantController < Api::V1::ApplicationController
  def show
    if params[:name].present? && !params[:name].empty?
      @merchant = Merchant.search_by_name(params[:name])

      if @merchant
        render json: @merchant, status: :ok
      else
        render json: {data: {}}, status: :ok
      end
    else
      render json: { messages: ['Illegal or missing search params given'] }, status: :bad_request
    end
  end
end
