require 'rails_helper'

RSpec.describe 'Search for items by name endpoint' do
  before {
    @merchant = create(:merchant)
    @item_1 = create(:item, name: 'Blarg', merchant: @merchant)
    @item_2 = create(:item, name: 'Pillow', merchant: @merchant)
    @item_3 = create(:item, name: 'Billowarg', merchant: @merchant)
    @item_4 = create(:item, name: 'Staples', merchant: @merchant)
  }

  describe 'GET /api/v1/items/find_all?name' do
    context 'find items by a name fragment' do
      it 'returns a list of matched item names' do
        get '/api/v1/items/find_all?name=aRg'

        items = json_list
        expect(response).to have_http_status 200
        expect(items.length).to eq 2
      end
    end
    
    context 'find items by a name fragment' do
      it 'returns nothing with status 200' do
        get '/api/v1/items/find_all?name=NOTHING'

        items = json_list
        expect(response).to have_http_status 200
        expect(items.length).to eq 0
      end
    end
  end
  
end
