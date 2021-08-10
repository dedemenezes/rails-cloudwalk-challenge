class Transaction < ApplicationRecord
  validates :transaction_id, :merchant_id, :user_id, :transaction_date, :transaction_amount, presence: true

  def self.chargebacks
    where(has_cbk: true)
  end

  def self.visas
    Transaction.where('card_number like ?', '4%')
  end
  
  def self.masters
    Transaction.where('card_number like ?', '5%')
  end

  def weekday
    is_weekend
    during_weekend
  end

  private

  def is_weekend
    weekend_condition = transaction_date.saturday? || transaction_date.sunday?
    if weekend_condition
      self.during_weekend = 1
    else
      self.during_weekend = 0 
    end
    save!
    during_weekend
  end
end
