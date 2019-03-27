require 'spec_helper'
require './calculater'
require 'ostruct'

describe 'Calculator' do
  let(:person)          { OpenStruct.new(goods_cost: 30_000, downpayment: 3000, term: 12, age: 44, employment: :own_business,  insurance: :job) }
  let(:call_to_console) { render_to_console_for(person) }
  let(:render_to_html)  { render_to_html_for(person) }

  context 'render to / display to' do
    it '#render_to_console_for' do
      expect{ call_to_console }.to output("Сумма займа: 30681.82
Первоначальный взнос 3000
Ежемесячный платеж: 2769.29
Срок кредита: 12 месяцев
Сумма выплат: 33231.48
Страхование: job, 3681.82
").to_stdout
    end

    it '#render_to_html_for' do
      expect(Launchy::Browser).to receive(:run).with("view/index.html")

      render_to_html
    end
  end

  context '#culculate' do
    let(:calculate)     { calculation(person) }

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
