class Api::V1::Merchants::ResourcesController < Api::V1::ApplicationController
  def index
    per_page = params.fetch(:per_page, 20).to_i
    page = params.fetch(:page, 1).to_i
    page = 1 if page < 1

    render jsonapi: Merchant.paginate(page, per_page)
  end

  def show
    render jsonapi: Merchant.find(params[:id]), status: :ok
  rescue StandardError
    render jsonapi: { errors: ['Resource not found'] }, status: :not_found
  end

  def create
    @merchant = Merchant.new(merchant_params)

    if @merchant.save
      render jsonapi: @merchant, status: :created
    else
      render jsonapi: { errors: @merchant.errors.full_messages },
             status: :bad_request
    end
  end

  def update
    @merchant = Merchant.find(params[:id])
    if @merchant.update(merchant_params)
      render jsonapi: @merchant, status: :accepted
    else
      render jsonapi: { errors: @merchant.errors.full_messages }, status: :bad_request
    end
  rescue StandardError
    render jsonapi: { errors: ['Resource not found'] }, status: :not_found
  end

  def destroy
    @merchant = Merchant.find(params[:id])
    render jsonapi: { meta: {} }, status: :no_content if @merchant.destroy
  rescue StandardError
    render jsonapi: { errors: ['Resource not found'] }, status: :not_found
  end

  private

  def merchant_params
    params.permit(:name)
  end
end
