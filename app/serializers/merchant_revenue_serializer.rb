class MerchantRevenueSerializer < ActiveModel::Serializer
  type :merchant_name_revenue
  attributes :name, :revenue
end
