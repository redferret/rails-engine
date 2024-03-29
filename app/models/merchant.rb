class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items

  def revenue
    self['revenue'] || 0.0
  end

  def count
    self['count'] || 0
  end

  def self.search_by_name(name)
    where('name Ilike ?', "%#{name}%").first
  end

  def self.total_revenue_by_descending_order(quantity, page = 1)
    total_price = '(invoice_items.unit_price * invoice_items.quantity)'

    records = joins('inner join invoices on invoices.merchant_id = merchants.id')
              .joins('inner join invoice_items on invoice_items.invoice_id = invoices.id')
              .joins('inner join transactions on transactions.invoice_id = invoices.id')
              .where(transactions: { result: :success })
              .select('merchants.*')
              .select("cast(sum( round (cast (float8 #{total_price} as numeric), 2)) as float) as revenue")
              .group('merchants.id').order('revenue desc')
    paginate(page, quantity, records)
  end

  def self.items_sold_descending_order(quantity, page = 1)
    records = joins('inner join invoices on invoices.merchant_id = merchants.id')
              .joins('inner join invoice_items on invoice_items.invoice_id = invoices.id')
              .joins('inner join transactions on transactions.invoice_id = invoices.id')
              .where(transactions: { result: :success })
              .select('merchants.*')
              .select('sum( invoice_items.quantity ) as count')
              .group('merchants.id').order('count desc')
    paginate(page, quantity, records)
  end

  def total_revenue
    total_price = '(invoice_items.unit_price * invoice_items.quantity)'
    Merchant.joins('inner join invoices on invoices.merchant_id = merchants.id')
            .joins('inner join invoice_items on invoice_items.invoice_id = invoices.id')
            .joins('inner join transactions on transactions.invoice_id = invoices.id')
            .where(transactions: { result: :success }, merchants: { id: id })
            .select('merchants.*')
            .select("cast(sum(round(cast(float8 #{total_price} as numeric), 2) ) as float) as revenue")
            .group(:id).first
  end
end
