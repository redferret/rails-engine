require 'rails_helper'

RSpec.describe 'Get an items merchant' do
  before {
    @merchant = create(:merchant)
    @item = create(:item, merchant: @merchant)
  }

  describe 'GET /api/v1/items/:item_id/merchant' do
    context 'gets the items merchant if found' do
      before { get "/api/v1/items/#{@item.id}/merchant" }

      it 'responds with status 200' do
        expect(response).to have_http_status 200
      end

      it 'returns the merchant' do
        merchant = json_single
        attributes = merchant[:attributes]

        expect(merchant[:id]).to eq @merchant.id
        expect(attributes[:name]).to eq @merchant.name
      end
    end

    context 'when an item is not found' do
      before { get '/api/v1/items/876578/merchant' }

      it 'responds with 404 status' do
        expect(response).to have_http_status 404
      end
    end
  end
end