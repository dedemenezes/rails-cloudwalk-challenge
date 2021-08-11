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

puts "cleaning db"
Transaction.destroy_all

puts "db clean zo/"
puts "generating transactions"
start_time = Time.now
CSV.foreach(filepath, csv_options) do |row|
  
  Transaction.create!(
    transaction_id: row['transaction_id'],
    merchant_id: row['merchant_id'],
    user_id: row['user_id'],
    bin: row['card_number'][0..5],
    mid: row['card_number'][12..-1],
    transaction_date: row['transaction_date'],
    transaction_amount: row['transaction_amount'].to_i * 100,
    device_id: row['device_id'],
    has_cbk:row['has_cbk'] 
    )
end

puts"Generated #{Transaction.count} transaction(s)\nTime elapsed: #{Time.now - start_time} seconds"

puts "Transforming datetime"
start_time = Time.now
Transaction.all.each { |transaction| transaction.transform_datetime }

puts "#{Transaction.first.inspect}\nTime elapsed: #{Time.now - start_time} seconds"

puts "Transforming user id"
start_time = Time.now
Transaction.all.each { |transaction| transaction.transform_user_id }

puts "#{Transaction.first.inspect}\nTime elapsed: #{Time.now - start_time} seconds"