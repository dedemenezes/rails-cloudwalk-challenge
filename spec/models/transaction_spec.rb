require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { 
    described_class.new(
      transaction_id:21320398,
      merchant_id: 29744,
      user_id: 97051,
      bin: 434505,
      mid: 9116,
      transaction_date: '2019-12-01T23:16:32.812632',
      transaction_amount: 37456,
      device_id: 285475,
      has_cbk: false 
    )
  }

  context "validations" do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
    it 'is not valid without transaction_id' do
      subject.transaction_id = nil
      expect(subject).to_not be_valid
    end
    it 'is not valid without merchant_id' do
      subject.merchant_id = nil
      expect(subject).to_not be_valid
    end
    it 'is not valid without user_id' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end
    it 'is not valid without transaction_date' do
      subject.transaction_date = nil
      expect(subject).to_not be_valid
    end
    it 'is not valid without transaction_amount' do
      subject.transaction_amount = nil
      expect(subject).to_not be_valid
    end
  end

  context 'data transformations' do
    
    it 'should be 0 for weekdays' do
      subject.transaction_date = '2019-11-28T23:16:32.812632'
      expect(subject.weekday).to eq(0)
    end
    
    it 'should be 1 for weekends' do
      expect(subject.weekday).to eq(1)
    end

  end
  
end
