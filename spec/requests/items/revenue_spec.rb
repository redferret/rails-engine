require 'rails_helper'

RSpec.describe 'items by revenue' do
  describe 'GET /api/v1/revenue/items?quantity=' do
    before :each do
      create_list(:merchant, 2) do |merchant|
        customer = create(:customer)
        create_list(:item, 30, merchant: merchant) do |item|
          invoice = create(:invoice, customer: customer, merchant: merchant)
          create(:invoice_item, item: item, invoice: invoice)
        end
      end
    end

    context 'gets 10 items' do
      before { get '/api/v1/revenue/items?quantity=10' }

      it 'returns status 200 with 10 items' do
        expect(response).to have_http_status 200

        items = json_list
        item = items.first

        expect(items.length).to eq 10
        expect(item).to have_key(:id)
        expect(item).to have_key(:type)
        expect(item).to have_key(:attributes)

        attributes = item[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:description)
        expect(attributes).to have_key(:unit_price)
        expect(attributes).to have_key(:merchant_id)
        expect(attributes).to have_key(:revenue)
      end
    end

    context 'gets all items if quantity is too big' do
      before { get '/api/v1/revenue/items?quantity=1000' }

      it 'returns status 200 with 60 items' do
        expect(response).to have_http_status 200

        items = json_list
        item = items.first

        expect(items.length).to eq 60
      end
    end

    context 'missing or bad param' do
      let(:expected_error_message) { 'Missing or invalid query paramter for quantity' }
      
      it 'returns status 400' do
        get '/api/v1/revenue/items?quantity'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq expected_error_message

        get '/api/v1/revenue/items?'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq expected_error_message

        get '/api/v1/revenue/items?quantity=afeahfu'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq expected_error_message
      end
    end
  end
end