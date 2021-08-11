module Transforms
  class MerchantRisk
    
  def self.get_merchants_ids(all_transactions)
    merchants_ids = []
    all_transactions.each do |t|
      next if merchants_ids.include? t.merchant_id
      merchants_ids << t.merchant_id
    end
    merchants_ids
    binding.pry
  end

  end
end