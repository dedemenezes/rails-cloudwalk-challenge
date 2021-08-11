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

  def weekend
    is_weekend
    during_weekend
  end

  def night_shop
    shop_time
    during_night
  end

  private

  def shop_time
    night_time = transaction_date.hour < 7
    if night_time
      self.during_night = 1
    else
      self.during_night = 0
    end
    save!
  end

  def is_weekend
    if transaction_date.on_weekend?
      self.during_weekend = 1
    else
      self.during_weekend = 0 
    end
    save!
  end
end
