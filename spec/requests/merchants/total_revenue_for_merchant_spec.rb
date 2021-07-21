require 'rails_helper'

RSpec.describe 'Merchant total revenue' do
  before :each do
    create_list(:merchant, 5) do |merchant|
      customer = create(:customer)
      create_list(:item, 5, merchant: merchant) do |item|
        invoice = create(:invoice, customer: customer, merchant: merchant)
        create(:invoice_item, item: item, invoice: invoice)
      end
    end
    @merchant = Merchant.sample
  end

  describe 'GET /api/v1/revenue/merchants/:id' do
    context 'gets the merchants revenue' do
      before { get "/api/v1/revenue/merchants/#{@merchant.id}" }

      it 'returns status 200 with the revenue data' do
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
      let(:expected_error_message) { 'Resource not found' }
      
      it 'returns status 404' do
        get "/api/v1/revenue/merchants/3248765"
        expect(response).to have_http_status 404

        error = errors
        expect(error).to have_key(:error)
        expect(error[:error]).to eq expected_error_message
      end
    end
  end
end