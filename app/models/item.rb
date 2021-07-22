class Item < ApplicationRecord
  validates :name, presence: true
  validates :unit_price, presence: true
  validates :description, presence: true

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  belongs_to :merchant

  def self.search_by_name(name)
    where('name Ilike ?', "%#{name}%")
  end

  def self.items_revenue_desc_order(quantity, page = 1)
    total_price = '(invoice_items.unit_price * invoice_items.quantity)'
    records = joins(:invoice_items, :invoices)
               .where(invoices: { status: :shipped })
               .select('items.*')
               .select("sum( round (cast (float8 #{total_price} as numeric), 2) ) as revenue")
               .group(:id).order(revenue: :desc)
    paginate(page, quantity, records)
  end
end
