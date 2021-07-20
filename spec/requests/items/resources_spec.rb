require 'rails_helper'

RSpec.describe 'Items CRUD' do
  before {
    Merchant.destroy_all
    @merchant = create(:merchant)
    80.times do 
      create(:item, merchant: @merchant)
    end
  }

  describe 'GET /api/v1/items' do
    context 'returns first 20 items with a 200 status' do
      before { get '/api/v1/items' }

      it 'returns with status 200' do
        expect(response).to have_http_status 200
      end

      it 'returns with first 20 items' do
        items = json_list
        first = items.first
        expect(items.length).to eq 20
        expect(first).to have_key(:id)
        expect(first).to have_key(:type)
        expect(first).to have_key(:attributes)
        attributes = first[:attributes]
        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:description)
        expect(attributes).to have_key(:unit_price)
        expect(attributes).to have_key(:merchant_id)
      end
    end
    
    context 'returns first 20 items when page = 1' do
      before { get '/api/v1/items?page=1' }

      it 'returns with status 200' do
        expect(response).to have_http_status 200
      end

      it 'returns with first 20 items' do
        items = json_list
        first = items.first
        expect(items.length).to eq 20
        expect(first).to have_key(:id)
        expect(first).to have_key(:type)
        expect(first).to have_key(:attributes)
        attributes = first[:attributes]
        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:description)
        expect(attributes).to have_key(:unit_price)
        expect(attributes).to have_key(:merchant_id)
      end
    end

    context 'returns first 20 items when page = 0' do
      before { get '/api/v1/items?page=0' }

      it 'returns with status 200' do
        expect(response).to have_http_status 200
      end

      it 'returns with first 20 items' do
        items = json_list
        first = items.first
        expect(items.length).to eq 20
        expect(first).to have_key(:id)
        expect(first).to have_key(:type)
        expect(first).to have_key(:attributes)
        attributes = first[:attributes]
        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:description)
        expect(attributes).to have_key(:unit_price)
        expect(attributes).to have_key(:merchant_id)
      end
    end

    context 'returns next 20 items when page = 2' do
      before { get '/api/v1/items?page=2' }

      it 'returns with status 200' do
        expect(response).to have_http_status 200
      end

      it 'returns with second 20 items' do
        items = json_list
        first = items.first
        expect(items.length).to eq 20
        expect(first).to have_key(:id)
        expect(first).to have_key(:type)
        expect(first).to have_key(:attributes)
        attributes = first[:attributes]
        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:description)
        expect(attributes).to have_key(:unit_price)
        expect(attributes).to have_key(:merchant_id)
      end
    end

    context 'returns next 50 items when per page = 50' do
      before { get '/api/v1/items?per_page=50' }

      it 'returns with status 200' do
        expect(response).to have_http_status 200
      end

      it 'returns with first 50 items' do
        items = json_list
        first = items.first
        expect(items.length).to eq 50
        expect(first).to have_key(:id)
        expect(first).to have_key(:type)
        expect(first).to have_key(:attributes)
        attributes = first[:attributes]
        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:description)
        expect(attributes).to have_key(:unit_price)
        expect(attributes).to have_key(:merchant_id)
      end
    end
  end

  describe 'POST /api/v1/items' do
    context 'when an item is created successfully' do
      let(:valid_attributes) { { name: 'Item 1', description: 'an item', unit_price: 12.50, merchant_id: @merchant.id } }
      before { post '/api/v1/items', params: valid_attributes }

      it 'responds with a status 201' do
        expect(response).to have_http_status 201
      end
    end

    context 'when an item has invalid attributes' do
      let(:invalid_attributes_1) { { description: 'an item', unit_price: 12.50, merchant_id: @merchant.id} }
      let(:invalid_attributes_2) { { name: 'Item 1', unit_price: 12.50, merchant_id: @merchant.id } }
      let(:invalid_attributes_3) { { name: 'Item 1', description: 'an item', merchant_id: @merchant.id } }
      let(:invalid_attributes_4) { { name: 'Item 1', description: 'an item', unit_price: 12.50 } }

      it 'responds with a status 422, no name' do
        post '/api/v1/items', params: invalid_attributes_1
        expect(response).to have_http_status 400
      end

      it 'responds with a status 422, no description' do
        post '/api/v1/items', params: invalid_attributes_2
        expect(response).to have_http_status 400
      end

      it 'responds with a status 422, no unit_price' do
        post '/api/v1/items', params: invalid_attributes_3
        expect(response).to have_http_status 400
      end

      it 'responds with a status 422, no merchant_id' do
        post '/api/v1/items', params: invalid_attributes_4
        expect(response).to have_http_status 400
      end
    end
  end

  describe 'GET /api/v1/items/:id' do
    context 'when an item is found successfully' do
      let(:item_id) { Item.first.id }
      before { get "/api/v1/items/#{item_id}"}

      it 'responds with status 200' do
        expect(response).to have_http_status 200
      end

      it 'returns the item with an id, type, and attributes' do
        attributes = json_single[:attributes]
        item = Item.find(item_id)

        expect(json_single[:id]).to eq item.id
        expect(attributes[:name]).to eq item.name
        expect(attributes[:description]).to eq item.description
        expect(attributes[:unit_price]).to eq item.unit_price
        expect(attributes[:merchant_id]).to eq @merchant.id
      end
    end
    
    context 'when an item is not found' do
      before { get "/api/v1/items/789"}

      it 'responds with status 404' do
        expect(response).to have_http_status 404
      end
    end
  end

  describe 'PUT /api/v1/items/:id' do
    context 'when an item is updated successfully' do
      let(:valid_attributes) { { name: 'New Name' } }
      it 'responds with status 201' do
        item = Item.first
        put "/api/v1/items/#{item.id}", params: valid_attributes

        item.reload

        expect(response).to have_http_status 202
        expect(item.name).to eq 'New Name'
      end
    end

    context 'when an item is not found to be updated' do
      it 'responds with status 404' do
        put '/api/v1/items/865467'

        expect(response).to have_http_status 404
      end
    end
  end

  describe 'DELETE /api/v1/items/:id' do
    context 'when an item is deleted successfully' do
      it 'repsonds with status 204' do
        item_id = Item.first.id
        delete "/api/v1/items/#{item_id}"
        
        expect(response).to have_http_status 204
      end
    end

    context 'when an item is not found to be deleted' do
      it 'responds with status 404' do
        delete '/api/v1/items/879654567'
        
        expect(response).to have_http_status 404
      end
    end
  end
end
