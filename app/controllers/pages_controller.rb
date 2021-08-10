class PagesController < ApplicationController

  def home
    @transactions = Transaction.all
  end
end
