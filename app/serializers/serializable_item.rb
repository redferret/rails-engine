class SerializableItem < JSONAPI::Serializable::Resource
  type 'items'

  attributes :name, :description, :unit_price, :merchant_id

  belongs_to :merchant do
    meta do
      { name: @object.merchant.name }
    end
  end

  has_many :invoice_items
end
