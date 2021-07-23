require 'rails_helper'

RSpec.describe 'Merchants by items sold endpoint' do
  before :each do
    create_list(:merchant, 20) do |merchant|
      customer = create(:customer)
      create_list(:invoice, 3, customer: customer, merchant: merchant) do |invoice|
        create_list(:item, 3, merchant: merchant) do |item|
          create(:invoice_item, item: item, invoice: invoice)
        end
        create(:transaction, result: :success, invoice: invoice)
      end
    end
  end

  describe 'GET /api/v1/merchants/most_items?quantity=' do
    context 'gets 10 merchants' do
      before { get '/api/v1/merchants/most_items?quantity=10' }

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
        expect(attributes).to have_key(:count)
      end
    end

    context 'gets all merchants if quantity is too big' do
      before { get '/api/v1/merchants/most_items?quantity=1000' }

      it 'returns status 200 with all merchants' do
        expect(response).to have_http_status 200

        merchants = json_list
        merchant = merchants.first

        expect(merchants.length).to eq 20
      end
    end

    context 'missing or bad param' do
      let(:expected_error_message) { 'Missing or invalid query paramter for quantity' }
      
      it 'returns status 400' do
        get '/api/v1/merchants/most_items?quantity'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq expected_error_message

        get '/api/v1/merchants/most_items?'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq expected_error_message

        get '/api/v1/merchants/most_items?quantity=afeahfu'
        expect(response).to have_http_status 400

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq expected_error_message
      end
    end
  end
end