class MerchantItemsSoldSerializer < ActiveModel::Serializer
  type :merchant
  attributes :name, :count
end
