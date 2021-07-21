class Api::V1::Items::SearchItemsController < Api::V1::ApplicationController
  def index
    if params[:name].present? && !params[:name].empty?
      @items = Item.search_by_name(params[:name])
      render_item
    else
      render json: { error: 'Illegal query parameter(s)', messages: ['Empty or missing search parameters given'] },
             status: :bad_request
    end
  end

  private

  def render_item
    if @items.empty?
      render json: { data: {} }, status: :ok
    else
      render json: @items, status: :ok
    end
  end
end
