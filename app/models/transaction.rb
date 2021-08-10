class Transaction < ApplicationRecord
  validates :transaction_id, :merchant_id, :user_id, :card_number, :transaction_date, :transaction_amount, presence: true

  def self.chargebacks
    where(has_cbk: true)
  end

  def self.visas
    Transaction.where('card_number like ?', '4%')
  end

  def self.merchant_than_five_cbks
    chargebacks.group(:merchant_id).count.select { |merchant, has_cbks| merchant if has_cbks > 4 }
  end

  def self.user_than_five_cbks
    chargebacks.group(:user_id).count.select { |user, has_cbks| user if has_cbks > 4 }
  end
end
