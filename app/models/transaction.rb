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

  def transform_datetime
    is_weekend
    shop_time
  end

  def self.get_users_transactions
    users_transactions = {}
    all.each do |t|
      unless users_transactions["#{t.user_id}"]
        users_transactions["#{t.user_id}"] = Transaction.where(user_id: t.user_id)
      end
    end

    users_transactions
  end

  def self.spending_behaviour(customer_id, window_size_days=[1,7,30])
    # find user transactions and order by transaction date
    customer_transactions = Transaction.where(user_id: customer_id[:user_id]).order(:transaction_date)
    binding.pry
    # loop over windows and set number of transactions by customer and avg amount spent on each window
    start_date = Date.new(2019,11,01)
    window_size_days.each_with_index do |days, index|
      range = ((start_date.beginning_of_day)..((start_date + days.day).end_of_day))
      range_transactions = customer_transactions.where(transaction_date: range)
      number_of_transactions = range_transactions.count
      total_amount_spent = range_transactions.sum(:transaction_amount)
      if number_of_transactions > 0
        avg_spent_amount = total_amount_spent / number_of_transactions 
      else
        avg_spent_amount = 0
      end
      range_transactions.each do |t|
        t.set_avg_amount(days, avg_spent_amount)
        t.set_number_of_transactions(days,number_of_transactions)
      end
      binding.pry
    end
    # return class Transaction
  end

  def set_number_of_transactions(days,number_of_transactions)
    case days
    when 1
      self.user_nb_tx_1Day_window = number_of_transactions
    when 7
      self.user_nb_tx_7Day_window = number_of_transactions
    when 30
      self.user_nb_tx_30Day_window = number_of_transactions
    else
      puts "oh diachu"
    end
    save!
  end
  
  def set_avg_amount(days, amount)
    case days
    when 1
      self.user_avg_amount_1Day_window = amount
    when 7
      self.user_avg_amount_7Day_window = amount
    when 30
      self.user_avg_amount_30Day_window = amount
    else
      puts "oh diachu"
    end
    save!
  end

  private
  
  def shop_time
    night_time = transaction_date.hour < 7
    night_time ? self.during_night = 1 : self.during_night = 0
    save!
  end

  def is_weekend
    transaction_date.on_weekend? ? self.during_weekend = 1 : self.during_weekend = 0 
    save!
  end
end
