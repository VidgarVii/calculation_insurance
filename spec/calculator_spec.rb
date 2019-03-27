require 'spec_helper'

describe Calculator do
  let(:person)    { OpenStruct.new(goods_cost: 30_000,
                                   downpayment: 3000,
                                   term: 12,
                                   age: 44,
                                   employment: :own_business,
                                   insurances: [:job]) }

  subject         { Calculator.new(person) }
  let(:calculate) { subject.insurance }

  describe '#culculate' do
    it 'return to hash' do
      expect(calculate).to be_is_a(Hash)
    end

    it 'assigns loan_amount' do
      expect(calculate[:loan_amount]).to eq 30_681.82
    end

    it 'assigns rate' do
      expect(calculate[:rate]).to eq 0.0125
    end

    it 'assigns monthly_payment' do
      expect(calculate[:monthly_payment]).to eq 2769.29
    end

    it 'assigns amount_to_pay' do
      expect(calculate[:amount_to_pay]).to eq 33_231.48
    end

    it 'assigns insurance' do
      expect(calculate[:insurance]).to eq 3681.82
    end

    context 'for all in' do
      let(:person_all_in) { OpenStruct.new(goods_cost: 30_000,
                                           downpayment: 3000,
                                           term: 12,
                                           age: 44,
                                           employment: :own_business,
                                           insurances: %i[life job]) }
      subject             { Calculator.new(person_all_in) }
      let(:calculate)     { subject.insurance }

      it 'assigns loan_amount' do
        expect(calculate[:loan_amount]).to eq 35_217.82
      end

      it 'assigns monthly_payment' do
        expect(calculate[:monthly_payment]).to eq 3178.7
      end

      it 'assigns amount_to_pay' do
        expect(calculate[:amount_to_pay]).to eq 38_144.4
      end

      it 'assigns insurance' do
        expect(calculate[:insurance]).to eq 8217.82
      end

    end
  end
end
