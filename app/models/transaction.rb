class Transaction < ApplicationRecord
  validates :credit_card_number, presence: true, numericality: true
  validates :result, presence: true

  enum result: {failed: 'failed', success: 'success'}

  belongs_to :invoice
end
