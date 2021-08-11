module Transforms
  class UserId
    def self.spending_behaviour(customer_id, customer_transactions, window_size_days=[1,7,30])
      start_date = Date.new(2019,11,01)
      # find user transactions and order by transaction date
      window_user_behaviours = {}
      # loop over windows and set number of transactions by customer and avg amount spent on each window
      window_size_days.each do |window_days|
        # Create user behavuour for each window days
        window_user_behaviours["#{window_days}"] = get_window_transactions(start_date, window_days, customer_transactions)
      end
      window_user_behaviours
    end

    def self.get_window_transactions(start_date, window, transactions)
      end_date = Date.new(2019,12,01)
      range = ((start_date.beginning_of_day)..((start_date + window.day).end_of_day))
      if (start_date + window.day).end_of_day > end_date.end_of_day
        range = ((start_date.beginning_of_day)..(end_date.end_of_day))
      end
      range_transactions = transactions.where(transaction_date: range)
      range_transactions.present? ? get_window_behaviour(range_transactions) : get_window_behaviour(0)
    end

    def self.get_window_behaviour(transactions)
      if transactions == 0
        { avg_amount: 0, nbr_transactions: 0 }
      else
        { avg_amount: transactions.sum(:transaction_amount) / transactions.count,
          nbr_transactions: transactions.count
        }  
      end
    end
  end
end
