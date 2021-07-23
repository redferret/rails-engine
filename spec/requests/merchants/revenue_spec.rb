require 'rails_helper'

RSpec.describe 'Merchants by revenue' do
  describe 'GET /api/v1/revenue/merchants/:id' do
    before :each do
      create_list(:merchant, 5) do |merchant|
        customer = create(:customer)
        create_list(:item, 5, merchant: merchant) do |item|
          invoice = create(:invoice, customer: customer, merchant: merchant)
          create(:invoice_item, item: item, invoice: invoice)
        end
      end
      @merchant = Merchant.all.sample
    end

    context 'gets the merchants revenue' do
      it 'returns status 200 with the revenue data' do
        get "/api/v1/revenue/merchants/#{@merchant.id}"
        expect(response).to have_http_status 200

        merchant = json_single

        expect(merchant).to have_key(:id)
        expect(merchant).to have_key(:type)
        expect(merchant).to have_key(:attributes)

        attributes = merchant[:attributes]

        expect(attributes).to have_key(:revenue)
      end
    end

    context 'merchant not found' do
      it 'returns status 404' do
        get "/api/v1/revenue/merchants/3248765"
        expect(response).to have_http_status 404

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq 'Resource not found'
      end
    end
  end

  describe 'GET /api/v1/revenue/merchants?quantity=' do
    before :each do
      create_list(:merchant, 30) do |merchant|
        customer = create(:customer)
        create_list(:item, 5, merchant: merchant) do |item|
          invoice = create(:invoice, customer: customer, merchant: merchant)
          create(:invoice_item, item: item, invoice: invoice)
        end
      end
    end

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

    context 'when merchant has no sales' do
      it 'returns status 200 with revenue equal to 0' do
        merchant_1 = create(:merchant)
        get "/api/v1/revenue/merchants/#{merchant_1.id}"

        merchant = json_single
        expect(response).to have_http_status 200
        expect(merchant).to have_key(:id)
        expect(merchant).to have_key(:type)
        expect(merchant).to have_key(:attributes)

        attributes = merchant[:attributes]

        expect(attributes).to have_key(:revenue)
        expect(attributes[:revenue]).to eq 0.0
      end
    end

    context 'missing or bad param' do
      let(:expected_error_message) { 'Missing or invalid query paramter for quantity' }
      
      it 'returns status 400' do
        get '/api/v1/revenue/merchants?quantity'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq expected_error_message

        get '/api/v1/revenue/merchants?'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq expected_error_message

        get '/api/v1/revenue/merchants?quantity=afeahfu'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq expected_error_message
      end
    end
  end
end