class Calculator
  INSURANCES = { job: :calculate_job,
                 life: :calculate_life }.freeze

  def initialize(client)
    @client = client
    @insurance_amount = 0
  end

  def insurance
    run_calculate

    { loan_amount: total_loan_amount,
      rate: rate,
      monthly_payment: monthly_payment,
      amount_to_pay: amount_to_pay,
      insurance: @insurance_amount.round(2) }
  end

  private

  # rate - этот параметр надо как-то по другому передавать. Из вне.
  # Так как для меня это магические цифры.
  # либо RATE = 0.0125
  def rate
    15 / 1200.0
  end

  def amount_to_pay
    (monthly_payment * @client.term).round(2)
  end

  # порядок расчета введется по порядку ключей
  # 1 - job
  # 2 - life
  # для смены порядка расчетов надо поменять ключи в константе INSURANCES местами
  def run_calculate
    return 0.0 if @client.insurances.empty?

    INSURANCES.each_key do |type|
      send INSURANCES[type] if @client.insurances.include?(type)
    end
  end

  def monthly_payment
    @monthly_payment ||=
      (rate * (rate + 1)**@client.term / ((rate + 1)**@client.term - 1) * total_loan_amount).round(2)
  end

  def total_loan_amount
    @total_loan_amount ||= (loan_amount + @insurance_amount).round(2)
  end

  def calculate_life
    @insurance_amount +=
      if @client.age < 30
        loan_amount * (1.1 / 100.0) * @client.term
      elsif @client.age < 60
        loan_amount * (1.4 / 100.0) * @client.term
      else
        loan_amount * (1.8 / 100.0) * @client.term
      end
  end

  def calculate_job
    @insurance_amount +=
      case @client.employment
      when :own_business
        loan_amount / (1 - @client.term / 100.0) - loan_amount
      when :clerk
        loan_amount * 0.014
      else
        0.00
      end
  end

  def loan_amount
    @loan_amount ||= @client.goods_cost - @client.downpayment
  end
end
