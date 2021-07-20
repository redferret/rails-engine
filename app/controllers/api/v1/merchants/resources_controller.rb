class Api::V1::Merchants::ResourcesController < Api::V1::ApplicationController
  def index
    per_page = params.fetch(:per_page, 20).to_i
    page = params.fetch(:page, 1).to_i
    page = 1 if page < 1

    render json: Merchant.paginate(page, per_page), status: :ok
  end

  def show
    @merchant = Merchant.find(params[:id])
    render json: @merchant, status: :ok
  rescue StandardError
    render json: { messages: ['Count not find Merchant'] }, status: :not_found
  end

  def create
    @merchant = Merchant.new(merchant_params)

    if @merchant.save
      render json: @merchant, status: :created
    else
      render json: { error: 'Item could not be created', messages: @merchant.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    @merchant = Merchant.find(params[:id])

    if @merchant.update(merchant_params)
      render json: @merchant, status: :accepted
    else
      render json: { messages: ['Count not update merchant'] },
             status: :unprocessable_entity
    end
  rescue StandardError
    render json: { messages: ['Count not find Item to update'] }, status: :not_found
  end

  def destroy
    @merchant = Merchant.find(params[:id])
    render json: { messages: ['Merchant deleted'] }, status: :no_content if @merchant.destroy
  rescue StandardError
    render json: { messages: ['Merchant not found'] }, status: :not_found
  end

  private

  def merchant_params
    params.permit(:name)
  end
end
