class Api::V1::Merchants::SearchMerchantController < Api::V1::ApplicationController
  def show
    if params[:name].present? && !params[:name].empty?
      @merchant = Merchant.search_by_name(params[:name])
      render_merchant
    else
      render json: { error: 'Illegal query parameter(s)', messages: ['Empty or missing search parameters given'] },
             status: :bad_request
    end
  end

  private

  def render_merchant
    if @merchant
      render json: @merchant, status: :ok
    else
      render json: { data: {}, messages: ['No Matches'] }, status: :ok
    end
  end
end
