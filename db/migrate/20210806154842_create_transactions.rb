class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.integer :transaction_id
      t.integer :merchant_id
      t.integer :user_id
      t.string :card_number
      t.date :transaction_date
      t.integer :transaction_amount
      t.integer :device_id
      t.boolean :has_cbk

      t.timestamps
    end
  end
end
