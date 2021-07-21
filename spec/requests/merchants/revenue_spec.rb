require 'rails_helper'

RSpec.describe 'Merchants by revenue' do
  before :each do
    create_list(:merchant, 30) do |merchant|
      create_list(:item, 5, merchant: merchant) do |item|
        customer = create(:customer)
        invoice = create(:invoice, customer: customer, merchant: merchant)
        create(:invoice_item, item: item, invoice: invoice)
      end
    end
  end

  describe 'GET /api/v1/revenue/merchants?quantity=' do
    context 'gets 10 merchants' do
      before { get '/api/v1/revenue/merchants?quantity=10' }

      it 'returns status 200 with 10 merchants' do
        expect(response).to have_http_status 200

        merchants = json_list
        merchant = merchants.first

        expect(merchants.length).to eq 10
        expect(merchant).to have_key(:id)
        expect(merchant).to have_key(:type)
        expect(merchant).to have_key(:attributes)

        attributes = merchant[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:revenue)
      end
    end

    context 'gets all merchants if quantity is too big' do
      before { get '/api/v1/revenue/merchants?quantity=1000' }

      it 'returns status 200 with 30 merchants' do
        expect(response).to have_http_status 200

        merchants = json_list
        merchant = merchants.first

        expect(merchants.length).to eq 30
      end
    end

    context 'missing or bad param' do
      it 'returns status 400' do
        get '/api/v1/revenue/merchants?quantity'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq 'Missing or invalid query paramter for quantity'

        get '/api/v1/revenue/merchants?'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq 'Missing or invalid query paramter for quantity'

        get '/api/v1/revenue/merchants?quantity=afeahfu'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq 'Missing or invalid query paramter for quantity'
      end
    end
  end
end