require 'rails_helper'

RSpec.describe 'Get Merchants API Endpoint' do
  # Initialize the test data
  before { 
    40.times do
      FactoryBot.create(:merchant)
    end
  }

  describe 'GET /api/v1/merchants' do
    context 'when merchants page is not given as a param' do
      before { get '/api/v1/merchants' }

      it 'returns status code 200' do
        @first_merchant = Merchant.first
        first = json_list.first
        expect(response).to have_http_status 200
        expect(json_list.length).to eq 20
        expect(first[:id]).to eq @first_merchant.id
        expect(first[:attributes][:name]).to eq @first_merchant.name
      end
    end
    
    context 'when merchants page is given' do
      it 'returns status code 200' do
        get '/api/v1/merchants?page=1'
        @first_merchant = Merchant.first
        
        first = json_list.first
        expect(response).to have_http_status 200
        expect(json_list.length).to eq 20
        expect(first[:id]).to eq @first_merchant.id
        expect(first[:attributes][:name]).to eq @first_merchant.name
      end
      
      it 'returns next 20 merchants' do
        get '/api/v1/merchants?page=2'
        @first_merchant = Merchant.first
        
        first = json_list.first
        expect(response).to have_http_status 200
        expect(json_list.length).to eq 20
        expect(first[:id]).to_not eq @first_merchant.id
        expect(first[:attributes][:name]).to_not eq @first_merchant.name
      end
    end

    context 'when invalid page is given returns page 1 instead' do
      it 'returns status code 200' do
        get '/api/v1/merchants?page=0'
        @first_merchant = Merchant.first
        
        first = json_list.first
        expect(response).to have_http_status 200
        expect(json_list.length).to eq 20
        expect(first[:id]).to eq @first_merchant.id
        expect(first[:attributes][:name]).to eq @first_merchant.name
      end
    end
  end
end
