class SerializableMerchant < JSONAPI::Serializable::Resource
  type 'merchants'

  attributes :name, :revenue, :count

  has_many :items
  has_many :invoices
end
