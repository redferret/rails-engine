require 'rails_helper'

RSpec.describe 'Invoice CRUD endpoints' do
  before :each do
    create_list(:merchant, 5) do |merchant|
      customer = create(:customer)
      create_list(:invoice, 3, customer: customer, merchant: merchant)
    end
    @invoice = Invoice.all.sample
  end

  describe 'GET /api/v1/invoices/:id' do
    context 'when the request is successful' do
      it 'returns expected data with status 200' do
        get "/api/v1/invoices/#{@invoice.id}"

        expect(response).to have_http_status 200

        invoice = json_single

        expect(invoice).to have_key(:id)
        expect(invoice).to have_key(:type)
        expect(invoice).to have_key(:attributes)

        attributes = invoice[:attributes]

        expect(attributes).to have_key(:merchant_id)
        expect(attributes).to have_key(:customer_id)
        expect(attributes).to have_key(:status)
      end
    end

    context 'when invoice does not exist/not found' do
      it 'returns 404 status with error message' do
        get '/api/v1/invoices/765445465'

        expect(response).to have_http_status 404

        error = errors

        expect(error).to have_key(:error)
        expect(error).to have_key(:messages)
        expect(error[:error]).to eq 'Resource not found'
      end
    end
  end

  describe 'POST /api/v1/invoices' do
    context 'when valid parameters' do
      it 'returns status 201 with expected data' do
        customer = create(:customer)
        merchant = create(:merchant)
        post '/api/v1/invoices', params: { customer_id: customer.id, merchant_id: merchant.id }

        invoice = json_single

        expect(response).to have_http_status 201
        expect(invoice).to have_key(:id)
        expect(invoice).to have_key(:type)
        expect(invoice).to have_key(:attributes)

        attributes = invoice[:attributes]

        expect(attributes).to have_key(:customer_id)
        expect(attributes).to have_key(:merchant_id)
        expect(attributes).to have_key(:status)
        expect(attributes[:status]).to eq 'in_progress'
      end
    end

    context 'when missing or invalid parameters' do
      it 'returns with status 400 when missing parameters' do
        post '/api/v1/invoices', params: {}
        expect(response).to have_http_status 400

        error = errors
        
        expect(error).to have_key(:error)
        expect(error).to have_key(:messages)
      end
    end
  end

  describe 'PATCH, PUT /api/v1/invoices/:id' do
    context 'when successful update'

    context 'when invoice to update not found'
  end

  describe 'DELETE /api/v1/invoices/:id' do
    context 'when successful delete'

    context 'when invoice to delete not found'
  end
end