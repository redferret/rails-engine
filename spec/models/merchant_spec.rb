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
end