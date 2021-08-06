class PagesController < ApplicationController
  before_action :has_chargeback

  def home
    first_week_transactions
    @transactions = Transaction.all
    @user = Transaction.where(user_id:79054)
    date = Date.new(2019,11,29)
    @first_day = Transaction.where(transaction_date: date.beginning_of_day..(date.beginning_of_day + (86400)))
    @first_day_chargebacks = Transaction.where(transaction_date: date.beginning_of_day..(date.beginning_of_day + (86400))).where(has_cbk: true)
  end

  def bigger_than_two_hundred
    @two_plus = Transaction.where('transaction_amount > ?', 20000)
  end

  def discover_transactions
    Transaction.where('card_number like ?', '6%')
  end

  def master_transactions
    Transaction.where('card_number like ?', '5%').count
  end

  def visa_transactionbs
    Transaction.where('card_number like ? and has_cbk = true', '4%')
  end

  def first_week_transactions
    date = Date.new(2019,11,29)
    @week_transactions = Transaction.where(transaction_date: date.beginning_of_day..(date.beginning_of_day + (86400 * 7)))
  end

  def five_or_more
    @five_or_more = @chargeback.group(:user_id).count.select{|user, cbk_count| user if cbk_count > 4 }
  end

  private
  def more_than_four_transactions
    Transaction.group(:user_id).count.select { |usr, trs| usr if trs > 4 }
  end

  def more_devices
    more_than_four_transactions.map { |usr, trs| Transaction.where('user_id = ?', usr)}
  end

  def has_chargeback
    @chargebacks = Transaction.where(has_cbk: true)
  end
end
