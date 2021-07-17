class Api::V1::Merchants::GetAllMerchantsController < Api::V1::ApplicationController
  def index
    page = params[:page].to_i if params[:page]
    page ||= 1
    if page < 1
      render json: { error: 'Page must greater than 0' }, status: :bad_request
    else
      from = (page - 1) * 20
      render json: Merchant.limit(20).offset(from), status: :ok
    end
  end
end
