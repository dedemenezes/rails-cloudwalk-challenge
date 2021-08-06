# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath    = 'db/transactions.csv'

Transaction.destroy_all

puts "db clean zo/"

CSV.foreach(filepath, csv_options) do |row|
  Transaction.create!(
    transaction_id: row['transaction_id'],
    merchant_id: row['merchant_id'],
    user_id: row['user_id'],
    card_number: row['card_number'],
    transaction_date: row['transaction_date'],
    transaction_amount: row['transaction_amount'],
    device_id: row['device_id'],
    has_cbk:row['has_cbk'] 
    )
end
binding.pry
puts Transaction.count