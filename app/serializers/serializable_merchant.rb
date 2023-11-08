class SerializableMerchant < JSONAPI::Serializable::Resource
  type 'merchants'

  attributes :name, :revenue

  has_many :items
  has_many :invoices
end
