class PagesController < ApplicationController
  before_action :has_chargeback

  def home
    @transactions = Transaction.all
    @user = Transaction.where(user_id:79054)
    date = Date.new(2019,11,29)
    @first_day = Transaction.where(transaction_date: date.beginning_of_day..(date.beginning_of_day + (86400)))
    @first_day_chargebacks = Transaction.where(transaction_date: date.beginning_of_day..(date.beginning_of_day + (86400))).where(has_cbk: true)
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
