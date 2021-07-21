class MerchantTotalRevenueSerializer < ActiveModel::Serializer
  type 'merchant_revenue'
  attributes :revenue
end