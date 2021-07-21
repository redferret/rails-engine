class Invoice < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  belongs_to :customer
  belongs_to :merchant

  enum status: { in_progress: 'in progress', cancelled: 'cancelled', shipped: 'shipped' }
end
