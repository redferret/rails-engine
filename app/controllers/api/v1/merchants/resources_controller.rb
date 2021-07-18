class Api::V1::Merchants::ResourcesController < Api::V1::ApplicationController
  def index
    page = params[:page].to_i if params[:page]
    page ||= 1
    page = 1 if page < 1
    per_page = params[:per_page].to_i if params[:per_page]
    per_page ||= 20

    from = (page - 1) * per_page
    render json: Merchant.limit(per_page).offset(from), status: :ok
  end

  def show
    @merchant = Merchant.find(params[:id])
    render json: @merchant, status: :ok
  rescue StandardError
    render json: { messages: ['Count not find Merchant']}, status: :not_found
  end
end
