class Api::V1::Merchants::MostItemsController < Api::V1::ApplicationController
  def index
    quantity = params[:quantity]
    if quantity && quantity.to_i != 0
      render jsonapi: Merchant.items_sold_descending_order(quantity.to_i)
    else
      render jsonapi: { errors: ['Missing or invalid query paramter for quantity'] }, status: :bad_request
    end
  end
end
