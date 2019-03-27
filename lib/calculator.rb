class Calculator
  def insurance(client)
    loan_amount = client.goods_cost
    loan_amount = loan_amount - client.downpayment

    insurance_amount =
        case client.insurances
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
end
