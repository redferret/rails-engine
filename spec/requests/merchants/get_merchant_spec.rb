require 'rails_helper'

RSpec.describe 'Get One Merchant API Endpoint' do
  # Initialize the test data
  before { 
    @merchant = FactoryBot.create(:merchant)
  }

  describe 'GET /merchant/:id' do
    context 'when merchants page is not given as a param' do
      before { get "/merchant/#{@merchant.id}" }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
        expect(json['id']).to eq @merchant.id
        expect(json['name']).to eq @merchant.name
      end
    end

    context 'when merchant does not exist' do
      it 'returns status code 404' do
        get '/merchant/12'

        expect(response).to have_http_status(404)
      end
    end
  end
end
