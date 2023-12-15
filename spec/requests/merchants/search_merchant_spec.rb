require 'rails_helper'

RSpec.describe 'Search for one Merchant API Endpoint' do
  let(:merchant) { create(:merchant, name: 'Piccolo') }

  describe 'GET /api/v1/merchant/find?name=' do
    context 'when a a match is found' do
      subject(:send_request) { get "/api/v1/merchants/find?name=#{merchant.name}" }
      it 'returns status code 200 with a merchant' do
        send_request

        merchant = json_single

        expect(response).to have_http_status 200
        expect(merchant[:id]).to eq @merchant.id
        expect(merchant[:attributes][:name]).to eq @merchant.name
      end
    end

    context 'when no match is found' do
      subject(:send_request) { get '/api/v1/merchants/find?name=NOMATCH' }

      it 'returns status code 200' do
        send_request

        merchant = json_single

        expect(merchant).to be_empty
        expect(response).to have_http_status 200
      end
    end

    context 'when no name param given' do
      subject(:send_request) { get '/api/v1/merchants/find' }

      it 'returns status 400' do
        send_request

        expect(response).to have_http_status 400
      end
    end
  end
end
