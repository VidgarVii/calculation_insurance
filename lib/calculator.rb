class Calculator
  INSURANCES = %i[job life]
  RATE = 15 / 1200.0

  def initialize(client)
    @client = client
  end

  def insurance
    { loan_amount: total_loan_amount,
      rate: RATE,
      monthly_payment: monthly_payment,
      amount_to_pay: amount_to_pay,
      insurance: insurance_amount.round(2)
    }
  end

  private

  def amount_to_pay
    (monthly_payment * @client.term).round(2)
  end

  def insurance_amount
    @insurance_amount ||= case @client.insurances
                          when :life
                            calculate_life
                          when :job
                            calculate_job
                          else
                            0.0
                          end
  end

  def monthly_payment
    @monthly_payment ||=
      (RATE * (RATE + 1)**@client.term / ((RATE + 1)**@client.term - 1) * total_loan_amount).round(2)
  end

  def total_loan_amount
    @total_loan_amount ||= (loan_amount + insurance_amount).round(2)
  end

  def calculate_life
    if @client.age < 30
      loan_amount * (1.1 / 100.0) * @client.term
    elsif @client.age < 60
      loan_amount * (1.4 / 100.0) * @client.term
    else
      loan_amount * (1.8 / 100.0) * @client.term
    end
  end

  def calculate_job
    case @client.employment
    when :own_business
      loan_amount / (1 - @client.term / 100.0 ) - loan_amount
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
