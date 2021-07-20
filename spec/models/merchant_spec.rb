require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
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
  end
end
