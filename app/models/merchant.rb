class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items

  def self.search_by_name(name)
    where('name Ilike ?', "%#{name}%").first
  end
end
