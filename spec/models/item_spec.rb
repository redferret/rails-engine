require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :description }
  end

  describe 'relationships' do
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should belong_to :merchant }
  end

  describe 'class method,' do
    context '::search_by_name' do
      it 'searches for items by name case insensitive' do
        merchant = create(:merchant)
        item_1 = create(:item, name: 'Blarg', merchant: merchant)
        item_2 = create(:item, name: 'Pillow', merchant: merchant)
        item_3 = create(:item, name: 'Billowarg', merchant: merchant)
        item_4 = create(:item, name: 'Staples', merchant: merchant)

        expected = [item_1, item_3]
        actual = Item.search_by_name('arG')
        expect(actual).to eq expected
      end
    end

    context '::items_revenue_desc_order' do
      it 'returns a list of items by revenue in desc order' do
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
        
        expected_results = [item_3, item_2, item_1]
        actual_results = Item.items_revenue_desc_order(3)

        expect(actual_results).to eq expected_results
      end
    end
  end
end
