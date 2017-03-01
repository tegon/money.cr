require "./money/*"

class Money
  class ConversionRateMissingError < Exception
  end

  property amount : Float64
  property currency : String

  @@base_currency = ""
  @@rates = {} of String => Float64

  def self.conversion_rates(base_currency, rates)
    @@base_currency = base_currency
    @@rates = rates
  end

  def self.base_currency
    @@base_currency
  end

  def self.rates
    @@rates
  end

  def self.conversion_rate_for(currency)
    if @@rates.has_key?(currency)
      @@rates[currency]
    else
      message = "Missing conversion rate for currency: #{currency}. Please set it using Money.conversion_rates"
      raise ConversionRateMissingError.new(message)
    end
  end

  def initialize(@amount : Float64, @currency : String)
  end

  def inspect
    "%.2f" % @amount + " #{@currency}"
  end

  def convert_to(new_currency)
    new_amount = if new_currency == @@base_currency
      @amount / Money.conversion_rate_for(@currency)
    else
      Money.conversion_rate_for(new_currency) * @amount
    end

    Money.new(new_amount, new_currency)
  end

  def +(money)
    new_amount = @amount + money.convert_to(@currency).amount
    Money.new(new_amount, @currency)
  end

  def -(money)
    new_amount = @amount - money.convert_to(@currency).amount
    Money.new(new_amount, @currency)
  end

  def *(value)
    new_amount = @amount * value
    Money.new(new_amount, @currency)
  end

  def /(value)
    new_amount = @amount / value
    Money.new(new_amount, @currency)
  end

  def ==(money)
    @amount == money.amount && @currency == money.currency
  end

  def >(money)
    @amount > money.amount
  end

  def >=(money)
    @amount >= money.amount
  end

  def <(money)
    @amount < money.amount
  end

  def <=(money)
    @amount <= money.amount
  end
end
