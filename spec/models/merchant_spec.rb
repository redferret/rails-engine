require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'class method,' do
    context '::search_by_name' do
      it 'searches a merchant by name case insensitive' do
        expected = create(:merchant, name: 'Piccolo')
        actual = Merchant.search_by_name('icC')
        expect(actual).to eq expected
      end
    end
  end

  describe 'class method,' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)

      item_1 = create(:item, unit_price: 10, merchant: @merchant_1)
      item_2 = create(:item, unit_price: 2, merchant: @merchant_2)
      item_3 = create(:item, unit_price: 100, merchant: @merchant_3)

      customer_1 = create(:customer)
      customer_2 = create(:customer)
      customer_3 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1, merchant: @merchant_1)
      invoice_2 = create(:invoice, customer: customer_2, merchant: @merchant_2)
      invoice_3 = create(:invoice, customer: customer_3, merchant: @merchant_3)

      create(:invoice_item, quantity: 1, unit_price: 10, item: item_1, invoice: invoice_1)
      create(:invoice_item, quantity: 2, unit_price: 2, item: item_2, invoice: invoice_2)
      create(:invoice_item, quantity: 3, unit_price: 100, item: item_3, invoice: invoice_3)
    end

    describe '::paginate' do
      it 'paginates records returned' do
        create_list(:merchant, 300)

        first = Merchant.first
        results = Merchant.paginate(1, 20)

        expect(results.count).to eq 20
        expect(results.first.id).to eq first.id

        results = Merchant.paginate(2, 100)

        nth_merchant = Merchant.limit(1).offset(100).first

        expect(results.count).to eq 100
        expect(results.first.id).to eq nth_merchant.id
      end
    end

    describe '::total_revenue_by_descending_order' do
      it 'returns merchants in decending order by revenue' do
        merchants = Merchant.total_revenue_by_descending_order(3)
        expected = [@merchant_3, @merchant_1, @merchant_2]

        expect(merchants).to eq expected
      end
    end

    describe '::items_sold_descending_order' do
      it 'returns merchants in decending order by items sold' do
        merchants = Merchant.items_sold_descending_order(3)
        expected = [@merchant_3, @merchant_2, @merchant_1]

        expect(merchants).to eq expected
      end
    end
    
  end
end
