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
  end
end
