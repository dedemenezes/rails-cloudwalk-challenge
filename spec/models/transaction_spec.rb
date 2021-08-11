require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { 
    described_class.new(
      transaction_id: 21321517,
      merchant_id: 99730,
      user_id: 16657,
      bin: 550209,
      mid: 4156,
      transaction_date: '2019-12-01T01:24:01.693230000',
      transaction_amount: 22400,
      device_id: 965552,
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

  context 'datetime transformations' do
    it 'during_weekend should be 0 for weekdays' do
      subject.transaction_date = '2019-11-28T23:16:32.812632'
      subject.transform_datetime
      expect(subject.during_weekend).to eq(0)
    end
    
    it 'during_weekend should be 1 for weekends' do
      subject.transform_datetime
      expect(subject.during_weekend).to eq(1)
    end

    it 'during_night should be 0 for daily purchases' do
      subject.transaction_date = '2019-11-28T13:16:32.812632'
      subject.transform_datetime
      expect(subject.during_night).to eq(0)
    end
    
    it 'during_night should be 1 for night purchases' do
      subject.transform_datetime
      expect(subject.during_night).to eq(1)
    end

  end  
end
