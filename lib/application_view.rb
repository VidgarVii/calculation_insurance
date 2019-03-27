class ApplicationView
  def render_to_console_for(client)
    response = calculation(client).insurance

    puts "Сумма займа: #{response[:loan_amount]}"
    puts "Первоначальный взнос #{client.downpayment}"
    puts "Ежемесячный платеж: #{response[:monthly_payment]}"
    puts "Срок кредита: #{client.term} месяцев"
    puts "Сумма выплат: #{response[:amount_to_pay] }"
    puts "Страхование: #{client.insurances}, #{response[:insurance]}"
  end

  require 'launchy'

  def render_to_html_for(client)
    response = calculation(client).insurance

    File.open('view/index.html','w') do |file|
      file.puts "<h1>Calculate</h1>"
      file.puts "<p>Сумма займа: #{response[:loan_amount]}"
      file.puts "<p>Первоначальный взнос #{client.downpayment}"
      file.puts "<p>Ежемесячный платеж: #{response[:monthly_payment]}"
      file.puts "<p>Сумма выплат: #{response[:amount_to_pay] }"
      file.puts "<p>Страхование: #{client.insurances}, #{response[:insurance]}</p>"
    end

    Launchy::Browser.run("view/index.html")
  end

  private

  def calculation(client)
    Calculator.new(client)
  end
end
