class PagesController < ApplicationController
  before_action :has_chargeback, :discover_transactions, :master_transactions, :visa_transactions

  def home
    first_week_transactions
    @transactions = Transaction.all
  end

  def bigger_than_two_hundred
    @two_plus = Transaction.where('transaction_amount > ?', 20000)
  end

  def discover_transactions
    @discover_transactions = Transaction.where('card_number like ?', '6%')
  end

  def master_transactions
    @master_transactions = Transaction.where('card_number like ?', '5%')
  end

  def visa_transactions
    @visa_transactions = Transaction.where('card_number like ?', '4%')
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
