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

  private

  def self.is_weekend(datetime)
    # Weekday from 0 to 6(Sunday to Saturday)
    if datetime.saturday? || datetime.sunday?
      puts 1
    else
      puts 0 
    end
  end
end
