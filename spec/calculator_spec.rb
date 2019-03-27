require 'spec_helper'

describe Calculator do
  subject         { Calculator.new }
  let(:person)    { OpenStruct.new(goods_cost: 30_000, downpayment: 3000, term: 12, age: 44, employment: :own_business,  insurances: :job ) }
  let(:calculate) { subject.insurance(person) }

  context '#culculate' do
    it 'return to hash' do
      expect(calculate).to be_is_a(Hash)
    end

    it 'assigns loan_amount' do
      expect(calculate[:loan_amount]).to eq 30681.82
    end

    it 'assigns rate' do
      expect(calculate[:rate]).to eq 0.0125
    end

    it 'assigns monthly_payment' do
      expect(calculate[:monthly_payment]).to eq 2769.29
    end

    it 'assigns amount_to_pay' do
      expect(calculate[:amount_to_pay]).to eq 33231.48
    end

    it 'assigns insurance' do
      expect(calculate[:insurance]).to eq 3681.82
    end
  end
end
