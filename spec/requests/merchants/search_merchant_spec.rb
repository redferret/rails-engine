require 'rails_helper'

RSpec.describe 'Search for one Merchant API Endpoint' do
  # Initialize the test data
  before { 
    @merchant = create(:merchant, name: 'Piccolo')
  }

  describe 'GET /api/v1/merchant/find?name=' do
    context 'successful search returns one merchant' do
      it 'returns status code 200 with a merchant' do
        get "/api/v1/merchants/find?name=#{@merchant.name}"
        
        merchant = json_single

        expect(response).to have_http_status 200
        expect(merchant[:id]).to eq @merchant.id
        expect(merchant[:attributes][:name]).to eq @merchant.name
      end
    end

    context 'successful search returns one merchant' do
      it 'returns status code 200 with a merchant' do
        get "/api/v1/merchants/find?name=NOMATCH"
        
        merchant = json_single

        expect(response).to have_http_status 200
      end
    end

    context 'no name param given' do
      it 'returns status 400' do
        get '/api/v1/merchants/find'
        expect(response).to have_http_status 400
      end
    end
  end
end
