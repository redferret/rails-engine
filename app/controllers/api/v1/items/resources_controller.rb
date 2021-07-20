class Api::V1::Items::ResourcesController < Api::V1::ApplicationController
  def index
    per_page = params.fetch(:per_page, 20).to_i
    page = params.fetch(:page, 1).to_i
    page = 1 if page < 1
    render json: Item.paginate(page, per_page), status: :ok
  end

  def show
    @item = Item.find(params[:id])
    render json: @item, status: :ok
  rescue StandardError
    render json: { error: 'Resource not found', messages: ["Couldn't find Item with id #{params[:id]}"] }, status: :not_found
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      render json: @item, status: :created
    else
      render json: { error: 'Failed to create resource', messages: @item.errors.full_messages },
             status: :bad_request
    end
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    render json: @item, status: :accepted
  rescue StandardError
    render json: { error: 'Resource not updated', messages: ["Couldn't find Item with id #{params[:id]}"] },
           status: :not_found
  end

  def destroy
    @item = Item.find(params[:id])
    render json: { messages: ['Item deleted'] }, status: :no_content if @item.destroy
  rescue StandardError
    render json: { error: 'Resource not found', messages: ["Couldn't find Item with id #{params[:id]}"] },
           status: :not_found
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
