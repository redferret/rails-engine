class Api::V1::Items::ResourcesController < Api::V1::ApplicationController
  def index
    per_page = params.fetch(:per_page, 20).to_i
    page = params.fetch(:page, 1).to_i
    page = 1 if page < 1
    render jsonapi: Item.paginate(page, per_page), status: :ok
  end

  def show
    @item = Item.find(params[:id])
    render jsonapi: @item, status: :ok
  rescue StandardError
    render json: { errors: ['Resource not found'] },
           status: :not_found
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      render jsonapi: @item, status: :created
    else
      render json: { errors: ["Failed to create resource: #{@item.errors.full_messages}"] },
             status: :bad_request
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      render jsonapi: @item, status: :accepted
    else
      render json: { errors: ["Failed to update resource: #{@item.errors.full_messages}"] }, status: :bad_request
    end
  rescue StandardError
    render json: { errors: ['Resource not found'] },
           status: :not_found
  end

  def destroy
    @item = Item.find(params[:id])
    render json: {}, status: :no_content if @item.destroy
  rescue StandardError
    render json: { errors: ['Resource not found'] },
           status: :not_found
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
