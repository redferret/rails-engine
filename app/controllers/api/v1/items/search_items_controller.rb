class Api::V1::Items::SearchItemsController < Api::V1::ApplicationController
  def index
    if params[:name].present? && !params[:name].empty?
      @items = Item.search_by_name(params[:name])

      if @items
        render json: @items, status: :ok
      else
        render json: { data: {} }, status: :ok
      end
    else
      render json: { messages: ['Illegal or missing search params given'] }, status: :bad_request
    end
  end
end
