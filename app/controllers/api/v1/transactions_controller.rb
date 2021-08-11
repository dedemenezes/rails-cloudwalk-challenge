class Api::V1::TransactionsController < Api::V1::BaseController

  def check
    @transaction = Transaction.new(transaction_params)
    @transaction.transform_datetime
    @transaction.transform_merchant_id
    @transaction.transform_user_id
    binding.pry
    limit_valid = TransactionValidators::TooLateTooBeTrue.above_limit(@transaction)
    if 
      render json: { "transaction_id": @transaction.transaction_id, "recommendation": "approve" }, status: :created
    else
      render_error
    end
  end

  # First score will vary from 0 to 1
  # Mechant risk will be counted as 1/3
  # during_night counted as 1/3
  # avg amount 1/3

  private

  def transaction_params
    params.require(:transaction).permit(:transaction_id, :merchant_id, :user_id, :bin, :mid, :transaction_date, :transaction_amount, :device_id)
  end

  def render_error
    render json: { errors: @transaction.errors.full_messages },
      status: :unprocessable_entity
  end
end