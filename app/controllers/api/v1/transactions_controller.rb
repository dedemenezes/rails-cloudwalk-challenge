class Api::V1::TransactionsController < Api::V1::BaseController

  def check
    @transaction = Transaction.new(transaction_params)
    limit_valid = TransactionValidators::TooLateTooBeTrue.above_limit(@transaction)
    binding.pry
  end

  # First score will vary from 0 to 1
  # Mechant risk will be counted as 1/3
  # during_night counted as 1/3
  # avg amount 1/3

  private

  def transaction_params
    params.require(:transaction).permit(:transaction_id, :merchant_id, :user_id, :bin, :mid, :transaction_date, :transaction_amount, :device_id)
  end
end