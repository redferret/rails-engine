class MerchantRevenueSerializer < ActiveModel::Serializer
  type :merchant
  attributes :name, :revenue
end
