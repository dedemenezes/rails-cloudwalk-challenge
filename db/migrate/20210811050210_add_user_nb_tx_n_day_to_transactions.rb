class AddUserNbTxNDayToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :user_nb_tx_1Day_window, :integer
    add_column :transactions, :user_nb_tx_7Day_window, :integer
    add_column :transactions, :user_nb_tx_30Day_window, :integer
  end
end
