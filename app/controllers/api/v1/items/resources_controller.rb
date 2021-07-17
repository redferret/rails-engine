class Api::V1::Items::ResourcesController < Api::V1::ApplicationController
  def index
    page = params[:page].to_i if params[:page]
    page ||= 1
    page = 1 if page < 1
    per_page = params[:per_page].to_i if params[:per_page]
    per_page ||= 20

    from = (page - 1) * per_page
    render json: Item.limit(per_page).offset(from), status: :ok
  end

  def show
    @item = Item.find(params[:id])
    render json: @item, status: :ok
  rescue StandardError
    render json: { error: 'Item not found' }, status: :not_found
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      render json: { messages: ['Item created'] }, status: :created
    else
      render json: { error: 'Item could not be created', messages: @item.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    @item = Item.find(params[:id])

    if @item.update(item_params)
      render json: { messages: ['Item updated'] }, status: :accepted
    else
      render json: { error: 'Could not update item', messages: @item.errors.full_messages },
             status: :unprocessable_entity
    end
  rescue StandardError
    render json: { error: 'Could not find item' }, status: :not_found
  end

  def destroy
    @item = Item.find(params[:id])
    render json: { messages: ['Item deleted'] }, status: :no_content if @item.destroy
  rescue StandardError
    render json: { error: 'Could not find item' }, status: :not_found
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
