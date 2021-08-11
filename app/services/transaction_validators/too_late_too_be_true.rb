module TransactionValidators
  class TooLateTooBeTrue
    def self.above_limit(transaction)
      usr_monthly_avg_amount = Transaction.find_by(user_id: transaction.user_id).user_avg_amount_30Day_window
      transaction.transform_datetime
      if transaction.during_night == 1 && transaction.during_weekend == 1
        transaction.transaction_amount <= usr_monthly_avg_amount + 25
      elsif transaction.during_night == 1
        transaction.transaction_amount <= usr_monthly_avg_amount + 45
      elsif transaction.during_weekend == 1
        transaction.transaction_amount <= usr_monthly_avg_amount + 95
      else
        true
      end
    end
  end
end