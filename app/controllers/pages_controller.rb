class PagesController < ApplicationController

  def home
    first_week_transactions
    @transactions = Transaction.all
  end
end
