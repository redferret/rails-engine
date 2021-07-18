require 'rails_helper'

RSpec.describe 'Merchant CRUD endpoints' do
  describe 'Create a new merchant endpoint' do
    describe 'POST /api/v1/merchant' do
      context 'when valid params' do
        let(:valid_params) { { name: 'New Merch' } }
        before { post '/api/v1/merchants', params: valid_params }

        it 'returns with status 201' do
          expect(response).to have_http_status 201
        end
      end

      context 'when invalid/no params' do
        before { post '/api/v1/merchants' }

        it 'returns with status 422' do
          expect(response).to have_http_status 422
        end
      end
    end
  end

  describe 'Update a merchant endpoint' do
    before {
      @merchant = create(:merchant)
    }

    describe 'PUT /api/v1/merchants/:id' do
      context 'when valid params' do
        before { put "/api/v1/merchants/#{@merchant.id}", params: { name: 'New Name' } }
        it 'returns with status 202' do
          expect(response).to have_http_status 202
        end
      end

      context 'when merchant to update does not exist' do
        before { put "/api/v1/merchants/3276843" }
        it 'returns with status 404' do
          expect(response).to have_http_status 404
        end
      end
    end
  end

  describe 'Deleting a merchant endpoint' do
    before {
      @merchant = create(:merchant)
    }

    describe 'DELETE /api/v1/merchants/:id' do
      context 'when valid params' do
        before { delete "/api/v1/merchants/#{@merchant.id}" }
        it 'returns with status 204' do
          expect(response).to have_http_status 204
        end
      end

      context 'when no merchant can be found to delete' do
        before { put "/api/v1/merchants/86756" }
        it 'returns with status 404' do
          expect(response).to have_http_status 404
        end
      end
    end
  end

  describe 'Get One Merchant API Endpoint' do
    before { 
      @merchant = create(:merchant)
    }

    describe 'GET /api/v1/merchant/:id' do
      context 'when merchants page is not given as a param' do
        before { get "/api/v1/merchants/#{@merchant.id}" }

        it 'returns status code 200' do
          expect(response).to have_http_status 200
          expect(json_single[:id]).to eq @merchant.id
          expect(json_single[:attributes][:name]).to eq @merchant.name
        end
      end

      context 'when merchant does not exist' do
        it 'returns status code 404' do
          get '/api/v1/merchants/12'

          expect(response).to have_http_status 404
        end
      end
    end
  end

  describe 'Get Merchants API Endpoint' do
    # Initialize the test data
    before { 
      40.times do
        create(:merchant)
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
  
      context 'when merchants per page is given' do
        it 'returns status code 200' do
          get '/api/v1/merchants?per_page=10'
          @first_merchant = Merchant.first
          
          first = json_list.first
          expect(response).to have_http_status 200
          expect(json_list.length).to eq 10
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
end
