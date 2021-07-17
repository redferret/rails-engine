require 'rails_helper'

RSpec.describe 'Get merchant items endpoint' do
  before {
    @merchant = FactoryBot.create(:merchant)
    10.times do
      FactoryBot.create(:item, merchant: @merchant)
    end
  }

  describe 'GET /api/v1/merchant/:merchant_id/items' do
    context 'valid merchant id' do
      it 'returns given merchants items' do
        get "/api/v1/merchants/#{@merchant.id}/items"

        expect(response).to have_http_status 200
        expect(json_list.length).to eq 10
      end
    end

    context 'invalid merchant id' do
      it 'returns given merchants items' do
        get '/api/v1/merchants/6/items'

        expect(response).to have_http_status 404
        expect(errors).to eq 'Merchant not found'
      end
    end
  end
end