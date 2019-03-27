require 'spec_helper'
require './calculater'
require 'ostruct'

describe 'Calculator' do
  let(:person)          { OpenStruct.new(goods_cost: 30_000, downpayment: 3000, term: 12, age: 44, employment: :own_business,  insurance: :job) }
  let(:call_to_console) { render_to_console_for(person) }
  let(:render_to_html)  { render_to_html_for(person) }
  let(:calculate)     { calculation(person) }

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
    it 'return to hash' do
      expect(calculate).to be_is_a(Hash)
    end
  end
end
