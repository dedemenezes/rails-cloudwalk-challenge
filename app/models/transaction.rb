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

  def transform_user_id
    # Get all users ids
    id = user_id
    # Do behaviour
    customer_transactions = Transaction.where(user_id: id).order(:transaction_date)
    user_behaviours = Transforms::UserId.spending_behaviour(id, customer_transactions)
    user_behaviours.each do |window_days ,user_behaviour|
      define_user_behaviour(user_behaviour, customer_transactions, window_days.to_i)
    end
  end

  def define_user_behaviour(user_behaviour, customer_transactions, days)
    daily_window(user_behaviour, customer_transactions) if days == 1
    weekly_window(user_behaviour, customer_transactions) if days == 7
    monthly_window(user_behaviour, customer_transactions) if days == 30
  end

  def get_users_ids(all_transactions)
    users_ids = []
    all_transactions.each do |t|
      unless users_ids.include? t.user_id
        users_ids << t.user_id
      end
    end
    users_ids
  end

  private

  def daily_window(user_behaviour, customer_transactions)
    customer_transactions.each do |t|
      t.user_nb_tx_1Day_window = user_behaviour[:nbr_transactions]
      t.user_avg_amount_1Day_window = user_behaviour[:avg_amount]
      t.save!
    end
  end

  def weekly_window(user_behaviour, customer_transactions)
    customer_transactions.each do |t|
      t.user_nb_tx_7Day_window = user_behaviour[:nbr_transactions]
      t.user_avg_amount_7Day_window = user_behaviour[:avg_amount]
      t.save!
    end
  end

  def monthly_window(user_behaviour, customer_transactions)
    customer_transactions.each do |t|
      t.user_nb_tx_30Day_window = user_behaviour[:nbr_transactions]
      t.user_avg_amount_30Day_window = user_behaviour[:avg_amount]
      t.save!
    end
  end

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
