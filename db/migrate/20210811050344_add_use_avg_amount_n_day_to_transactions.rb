class AddUseAvgAmountNDayToTransactions < ActiveRecord::Migration[6.1]
  def change 
    add_column :transactions, :user_avg_amount_1Day_window, :integer
    add_column :transactions, :user_avg_amount_7Day_window, :integer
    add_column :transactions, :user_avg_amount_30Day_window, :integer
  end
end
