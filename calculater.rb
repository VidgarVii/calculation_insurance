# Дано:
# Функция, выполняющая расчет стоимости кредита и выводящая результатаы на экран в текстовом формате. В связи с расширением бизнеса
# требуется дополнить функционал калькулятора.

# Задание:
# 1. Добавить возможность вывода результатов расчета в формате HTML (разметка на ваш выбор)
# 2. Реализовать возможность одновременной продажи страховки с типами :life и :job. В данном случае страховая
#    премия для типа :life должна быть рассчитана после того, как стоимость страховки с типом :job будет
#    добавлена к сумме займа (loan_amount)
# 3*. Провести рефакторинг на ваше усмотрение (задание со звездочкой)

def calculation(client)
  loan_amount = client.goods_cost
  loan_amount = loan_amount - client.downpayment

  insurance_amount =
      case client.insurance
      when :life
        if client.age < 30
          loan_amount * (1.1 / 100.0) * client.term
        elsif client.age < 60
          loan_amount * (1.4 / 100.0) * client.term
        else
          loan_amount * (1.8 / 100.0) * client.term
        end
      when :job
        case client.employment
        when :own_business
          loan_amount / (1 - client.term / 100.0 ) - loan_amount
        when :clerk
          loan_amount * 0.014
        else
          0.00
        end
      else
        0.0
      end

  loan_amount    += insurance_amount
  loan_amount     = loan_amount.round(2)
  rate            = 15 / 1200.0
  monthly_payment = (rate * (rate + 1)**client.term / ((rate + 1)**client.term - 1) * loan_amount).round(2)
  amount_to_pay   = (monthly_payment * client.term).round(2)
  insurance       = insurance_amount.round(2)

  { loan_amount: loan_amount, rate: rate, monthly_payment: monthly_payment, amount_to_pay: amount_to_pay, insurance: insurance }
end

def render_to_console_for(client)
  response = calculation(client)

  puts "Сумма займа: #{response[:loan_amount]}"
  puts "Первоначальный взнос #{client.downpayment}"
  puts "Ежемесячный платеж: #{response[:monthly_payment]}"
  puts "Срок кредита: #{client.term} месяцев"
  puts "Сумма выплат: #{response[:amount_to_pay] }"
  puts "Страхование: #{client.insurance}, #{response[:insurance]}"
end

require 'launchy'

def render_to_html_for(client)
  response = calculation(client)

  File.open('view/index.html','w') do |file|
    file.puts "<h1>Calculate</h1>"
    file.puts "<p>Сумма займа: #{response[:loan_amount]}"
    file.puts "<p>Первоначальный взнос #{client.downpayment}"
    file.puts "<p>Ежемесячный платеж: #{response[:monthly_payment]}"
    file.puts "<p>Сумма выплат: #{response[:amount_to_pay] }"
    file.puts "<p>Страхование: #{client.insurance}, #{response[:insurance]}</p>"
  end

  Launchy::Browser.run("view/index.html")
end
