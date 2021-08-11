class AddMerchantNbTx1DayWindow < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :merchant_nb_tx_1day_window, :integer
    add_column :transactions, :merchant_nb_tx_7day_window, :integer
    add_column :transactions, :merchant_nb_tx_30day_window, :integer
  end
end
