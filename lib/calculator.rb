class Calculator
  INSURANCES = { job: :calculate_job,
                 life: :calculate_life }.freeze
  RATE       = 0.0125 # 15 / 1200.0

  def initialize(client)
    @client = client
    @insurance_amount = 0
  end

  def insurance
    run_calculate

    { loan_amount: total_loan_amount,
      rate: RATE,
      monthly_payment: monthly_payment,
      amount_to_pay: amount_to_pay,
      insurance: @insurance_amount.round(2) }
  end

  private

  def amount_to_pay
    (monthly_payment * @client.term).round(2)
  end

  # the order of calculation is in the order of keys
  #   1 - job
  #   2 - life
  #   to change the order of calculations, you need to swap the keys in the constant INSURANCES
  def run_calculate
    return 0.0 if @client.insurances.empty?

    INSURANCES.each_key do |type|
      send INSURANCES[type] if @client.insurances.include?(type)
    end
  end

  def monthly_payment
    @monthly_payment ||=
      (RATE * (RATE + 1)**@client.term / ((RATE + 1)**@client.term - 1) * total_loan_amount).round(2)
  end

  def total_loan_amount
    @total_loan_amount ||= (loan_amount + @insurance_amount).round(2)
  end

  def age_factor
    return 1.1 if @client.age < 30
    return 1.4 if @client.age < 60

    1.8
  end

  def calculate_life
    @insurance_amount += loan_amount * (age_factor / 100.0) * @client.term
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
