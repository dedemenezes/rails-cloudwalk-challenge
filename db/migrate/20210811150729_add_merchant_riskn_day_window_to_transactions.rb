class AddMerchantRisknDayWindowToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :merchant_risk_1day_window, :float
    add_column :transactions, :merchant_risk_7day_window, :float
    add_column :transactions, :merchant_risk_30day_window, :float
  end
end
