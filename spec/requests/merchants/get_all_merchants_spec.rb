require 'rails_helper'

RSpec.describe 'Get Merchants API Endpoint' do
  # Initialize the test data
  before { 
    40.times do
      FactoryBot.create(:merchant)
    end
  }

  describe 'GET /merchants' do
    context 'when merchants page is not given as a param' do
      before { get '/merchants' }

      it 'returns status code 200' do
        @first_merchant = Merchant.first

        expect(response).to have_http_status 200
        expect(json.length).to eq 20
        expect(json.first['id']).to eq @first_merchant.id
        expect(json.first['name']).to eq @first_merchant.name
      end
    end
    
    context 'when merchants page is given' do
      it 'returns status code 200' do
        get '/merchants?page=1'
        @first_merchant = Merchant.first
        
        expect(response).to have_http_status 200
        expect(json.length).to eq 20
        expect(json.first['id']).to eq @first_merchant.id
        expect(json.first['name']).to eq @first_merchant.name
      end
      
      it 'returns next 20 merchants' do
        get '/merchants?page=2'
        @first_merchant = Merchant.first
        
        expect(response).to have_http_status 200
        expect(json.length).to eq 20
        expect(json.first['id']).to_not eq @first_merchant.id
      end
    end

    context 'when invalid page is given' do
      it 'returns status code 200' do
        get '/merchants?page=0'
        
        expect(response).to have_http_status 400
        expect(json['error']).to eq 'Page must greater than 0'
      end
    end
  end
end
