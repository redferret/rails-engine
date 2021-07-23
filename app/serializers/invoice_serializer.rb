class InvoiceSerializer < ActiveModel::Serializer
  type :invoice
  attributes :customer_id, :merchant_id, :status
end
