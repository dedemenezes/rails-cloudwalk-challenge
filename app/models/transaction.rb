require 'csv'

class Transaction < ApplicationRecord
  validates :transaction_id, :merchant_id, :user_id, :transaction_date, :transaction_amount, presence: true

  def transform_datetime
    is_weekend
    shop_time
  end

  def transform_user_id
    define_behaviour_windows
  end
  
  def define_behaviour_windows
    customer_transactions = Transaction.where(user_id: self.user_id).order(:transaction_date)
    user_behaviours = Transforms::UserId.spending_behaviour(self.user_id, customer_transactions)
    customer_transactions.each do |ct|
      set_transaction_window_behaviour(user_behaviours)
    end
  end

  # def get_users_ids(all_transactions)
  #   users_ids = []
  #   all_transactions.each do |t|
  #     unless users_ids.include? t.user_id
  #       users_ids << t.user_id
  #     end
  #   end
  #   users_ids
  # end

  def transform_merchant_id
    id = merchant_id
    merchant_txs = Transaction.where(merchant_id: id).order(:transaction_date)
    merchant_txs.each do |tx|
      merchant_risk = Transforms::MerchantId.get_merchant_risk(tx.merchant_id)
      set_merchant_risk_windows(merchant_risk)
    end
  end

  def self.store_transformed_data
    save_to_csv
  end

  private

  def self.save_to_csv
    headers = ['transaction_id', 'merchant_id', 'user_id', 'bin', 'mid', 'transaction_date', 'transaction_amount', 'device_id', 'has_cbk', 'during_weekend', 'during_night', 'user_nb_tx_1Day_window', 'user_nb_tx_7Day_window', 'user_nb_tx_30Day_window', 'user_avg_amount_1Day_window', 'user_avg_amount_7Day_window', 'user_avg_amount_30Day_window', 'merchant_nb_tx_1day_window', 'merchant_nb_tx_7day_window', 'merchant_nb_tx_30day_window', 'merchant_risk_1day_window', 'merchant_risk_7day_window', 'merchant_risk_30day_window']
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"', write_headers: true, headers: headers}
    filepath    = 'db/transformed_data.csv'

    CSV.open(filepath, 'wb', csv_options) do |csv|
      Transaction.all.each do |transaction|
        csv << [transaction.transaction_id, transaction.merchant_id, transaction.user_id, transaction.bin, transaction.mid, transaction.transaction_date, transaction.transaction_amount, transaction.device_id, transaction.has_cbk, transaction.during_weekend, transaction.during_night, transaction.user_nb_tx_1Day_window, transaction.user_nb_tx_7Day_window, transaction.user_nb_tx_30Day_window, transaction.user_avg_amount_1Day_window, transaction.user_avg_amount_7Day_window, transaction.user_avg_amount_30Day_window, transaction.merchant_nb_tx_1day_window, transaction.merchant_nb_tx_7day_window, transaction.merchant_nb_tx_30day_window, transaction.merchant_risk_1day_window, transaction.merchant_risk_7day_window, transaction.merchant_risk_30day_window]
      end
    end
  end

  def set_merchant_risk_windows(merchant_info_risk)
    self.merchant_risk_1day_window = merchant_info_risk["1"][:merchant_risk]
    self.merchant_risk_7day_window = merchant_info_risk["7"][:merchant_risk]
    self.merchant_risk_30day_window = merchant_info_risk["30"][:merchant_risk]
    self.merchant_nb_tx_1day_window = merchant_info_risk["1"][:window_transactions]
    self.merchant_nb_tx_7day_window = merchant_info_risk["7"][:window_transactions]
    self.merchant_nb_tx_30day_window = merchant_info_risk["30"][:window_transactions]
    save!
  end

  def set_transaction_window_behaviour(user_behaviours)
    self.user_nb_tx_1Day_window = user_behaviours["1"][:nbr_transactions]
    self.user_nb_tx_7Day_window = user_behaviours["7"][:nbr_transactions]
    self.user_nb_tx_30Day_window = user_behaviours["30"][:nbr_transactions]
    self.user_avg_amount_1Day_window = user_behaviours["1"][:avg_amount]
    self.user_avg_amount_7Day_window = user_behaviours["7"][:avg_amount]
    self.user_avg_amount_30Day_window = user_behaviours["30"][:avg_amount]
    save!
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
