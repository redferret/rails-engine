class Api::V1::Merchants::ItemsController < Api::V1::ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items unless @merchant.nil?
    render jsonapi: @items
  end
end
