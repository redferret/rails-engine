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
    render json: { error: ['Resource not found'], message: ["Couldn't find Merchant with id #{params[:id]}"] },
           status: :not_found
  end

  def create
    @merchant = Merchant.new(merchant_params)

    if @merchant.save
      render json: @merchant, status: :created
    else
      render json: { error: 'Resource not created', messages: @merchant.errors.full_messages },
             status: :bad_request
    end
  end

  def update
    @merchant = Merchant.find(params[:id])
    @merchant.update(merchant_params)
    render json: @merchant, status: :accepted
  rescue StandardError
    render json: { error: 'Resource not found', messages: ["Couldn't find Merchant with id #{params[:id]}"] },
           status: :not_found
  end

  def destroy
    @merchant = Merchant.find(params[:id])
    render json: { messages: ['Merchant deleted'] }, status: :no_content if @merchant.destroy
  rescue StandardError
    render json: { error: 'Resource not found', messages: ["Couldn't find Merchant with id #{params[:id]}"] },
           status: :not_found
  end

  private

  def merchant_params
    params.permit(:name)
  end
end
