module Transforms
  class MerchantId
    def self.get_merchants_ids(all_transactions)
      merchants_ids = []
      all_transactions.each do |t|
        next if merchants_ids.include? t.merchant_id
        merchants_ids << t.merchant_id
      end
      merchants_ids
    end

    def self.get_merchant_risk(merchant_id, delay_period=6, window_size_days=[1,7,30])
      start_date = Date.new(2019,11,01)
      end_date = Date.new(2019,12,01)
      id = merchant_id
      merchant_risk = {}
      # Delay period
      range_delay = ((start_date.beginning_of_day)..(start_date + delay_period.day).end_of_day)
      # Delay period all transactions
      merchant_transactions_delay_period = Transaction.where(merchant_id: id, transaction_date: range_delay).order(:transaction_date)
      # Delay period fraudulent transactions
      merchant_fraudulent_transactions_delay_period = merchant_transactions_delay_period.where(has_cbk: true)
  
      # Window period
      window_size_days.each do |window_size|
        # TODO
        range_window = ((start_date.beginning_of_day)..(start_date + delay_period.day + window_size.day).end_of_day)
        if (start_date + delay_period.day + window_size.day).end_of_day > end_date.end_of_day
          range_window = ((start_date.beginning_of_day)..(end_date.end_of_day))
        end
        # Window period all transactions
        merchant_transactions_delay_window_period = Transaction.where(merchant_id: id, transaction_date: range_window).order(:transaction_date)
        # Window period fradulent transactions
        merchant_fraudulent_transactions_delay_window_period = merchant_transactions_delay_window_period.where(has_cbk: true)
        #Check if exist any transaction within window period
        if merchant_transactions_delay_window_period.size > 0
          merchant_transactions_window_period = merchant_transactions_delay_window_period.count - merchant_transactions_delay_period.count
          merchant_fraudulent_transactions_window_period = merchant_fraudulent_transactions_delay_window_period.count - merchant_fraudulent_transactions_delay_period.count
          merchant_risk[window_size.to_s] = {
            merchant_risk: (merchant_fraudulent_transactions_window_period.to_f / merchant_transactions_window_period).round(5),
            window_transactions: merchant_transactions_window_period
          }
          if merchant_transactions_window_period == 0
            merchant_risk[window_size.to_s][:merchant_risk] = 0 
          end
        else
          merchant_risk[window_size.to_s] = {
            merchant_risk: 0.to_f,
            window_transactions: 0
          }
        end
      end
      merchant_risk
    end
  end
end