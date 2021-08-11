class Api::V1::TransactionsController < Api::V1::BaseController

  def check
    @transaction = Transaction.new(transaction_params)
    binding.pry
  end

  private

  def transaction_params
    params.require(:transaction).permit(:transaction_id, :merchant_id, :user_id, :card_number, :transaction_date, :transaction_amount, :device_id)
  end
end