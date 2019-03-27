require_relative 'lib/calculator'
require_relative 'lib/application_view'
require 'ostruct'

client = OpenStruct.new(goods_cost: 30_000, downpayment: 3000, term: 12, age: 44, employment: :own_business,  insurances: %i[life job])

p Calculator.new(client).insurance
