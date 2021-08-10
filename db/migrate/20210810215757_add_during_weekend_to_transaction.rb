class AddDuringWeekendToTransaction < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :during_weekend, :integer
  end
end
