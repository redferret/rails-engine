class Api::V1::Merchants::SearchMerchantController < Api::V1::ApplicationController
  def show
    if params[:name].present? && !params[:name].empty?
      @merchant = Merchant.search_by_name(params[:name])
      render jsonapi: @merchant
    else
      render json: { errors: ['Empty or missing search parameters'] },
             status: :bad_request
    end
  end
end
