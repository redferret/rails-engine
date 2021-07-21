class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items

  def self.search_by_name(name)
    where('name Ilike ?', "%#{name}%").first
  end

  def self.total_revenue_by_descending_order
    total_price = '(invoice_items.unit_price * invoice_items.quantity)'

    joins('inner join invoices on invoices.merchant_id = merchants.id')
      .joins('inner join invoice_items on invoice_items.invoice_id = invoices.id')
      .where(invoices: { status: :shipped })
      .select("merchants.*, sum( round (cast (float8 #{total_price} as numeric), 2) ) as invoice_revenue")
      .group('merchants.id').order('invoice_revenue desc')
  end
end
