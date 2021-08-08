class Transaction < ApplicationRecord
  validates :transaction_id, :merchant_id, :user_id, :card_number, :transaction_date, :transaction_amount, presence: true

  def self.chargebacks
    where(has_cbk: true)
  end

  def self.visas
    Transaction.where('card_number like ?', '4%')
  end
end
