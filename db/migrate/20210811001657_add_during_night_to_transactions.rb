class AddDuringNightToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :during_night, :integer
  end
end
