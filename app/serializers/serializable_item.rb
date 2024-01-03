class SerializableItem < JSONAPI::Serializable::Resource
  type 'items'

  attributes :name, :description, :unit_price, :merchant_id

  belongs_to :merchant

  has_many :invoice_items
end
