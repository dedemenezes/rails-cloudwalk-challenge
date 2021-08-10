class Transaction < ApplicationRecord
  validates :transaction_id, :merchant_id, :user_id, :card_number, :transaction_date, :transaction_amount, presence: true

  def self.chargebacks
    where(has_cbk: true)
  end

  def self.visas
    Transaction.where('card_number like ?', '4%')
  end
  
  def self.masters
    Transaction.where('card_number like ?', '5%')
  end

  def self.merchant_than_five_cbks
    chargebacks.group(:merchant_id).count.select { |merchant, has_cbks| merchant if has_cbks > 4 }
  end

  def self.user_than_five_cbks
    chargebacks.group(:user_id).count.select { |user, has_cbks| user if has_cbks > 4 }
  end

  def self.bigger_than_two_hundred
    @two_plus = Transaction.where('transaction_amount > ?', 20000)
  end

  def self.discover_transactions
    @discover_transactions = Transaction.where('card_number like ?', '6%')
  end

  def self.first_week_transactions
    date = Date.new(2019,11,29)
    @week_transactions = Transaction.where(transaction_date: date.beginning_of_day..(date.beginning_of_day + (86400 * 7)))
  end
end
