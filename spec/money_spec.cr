require "./spec_helper"

describe Money do
  Spec.before_each do
    Money.conversion_rates("EUR", { "USD" => 1.11, "Bitcoin" => 0.0047 })
  end

  describe "#initialize" do
    it "does set base_currency" do
      Money.base_currency.should eq("EUR")
    end

    it "does set rates" do
      rates = { "USD" => 1.11, "Bitcoin" => 0.0047 }
      Money.rates.should eq(rates)
    end

    it "does set amount" do
      fifty_eur = Money.new(50.0, "EUR")
      fifty_eur.amount.should eq(50.0)
    end

    it "does set currency" do
      fifty_eur = Money.new(50.0, "EUR")
      fifty_eur.currency.should eq("EUR")
    end
  end

  describe "#inspect" do
    it "returns amount and currency" do
      fifty_eur = Money.new(50.0, "EUR")
      fifty_eur.inspect.should eq("50.00 EUR")
    end
  end

  describe "#convert_to" do
    it "does convert to USD" do
      fifty_eur = Money.new(50.0, "EUR")
      conversion = fifty_eur.convert_to("USD")
      conversion.inspect.should eq("55.50 USD")
    end

    it "does convert to base_currency" do
      twenty_dollars = Money.new(20.0, "USD")
      conversion = twenty_dollars.convert_to("EUR")
      conversion.inspect.should eq("18.02 EUR")
    end

    it "does throw an error with unknow currency" do
      fifty_eur = Money.new(50.0, "EUR")
      expect_raises(Money::ConversionRateMissingError) do
        fifty_eur.convert_to("BRL")
      end
    end
  end

  describe "sum" do
    it "does sum two Money objects" do
      fifty_eur = Money.new(50.0, "EUR")
      twenty_dollars = Money.new(20.0, "USD")
      sum = fifty_eur + twenty_dollars
      sum.inspect.should eq("68.02 EUR")
    end
  end

  describe "subtraction" do
    it "does subtract two Money objects" do
      fifty_eur = Money.new(50.0, "EUR")
      twenty_dollars = Money.new(20.0, "USD")
      subtraction = fifty_eur - twenty_dollars
      subtraction.inspect.should eq("31.98 EUR")
    end
  end

  describe "multiplication" do
    it "does multiply a Money object" do
      twenty_dollars = Money.new(20.0, "USD")
      multiplication = twenty_dollars * 3
      multiplication.inspect.should eq("60.00 USD")
    end
  end

  describe "division" do
    it "does divide a Money object" do
      fifty_eur = Money.new(50.0, "EUR")
      division = fifty_eur / 2
      division.inspect.should eq("25.00 EUR")
    end
  end

  describe "equals" do
    it "is equal iwth same currency and amount" do
      twenty_dollars = Money.new(20.0, "USD")
      twenty_dollars.should eq(Money.new(20.0, "USD"))
    end

    it "is not equal with same currency and different amount" do
      twenty_dollars = Money.new(20.0, "USD")
      twenty_dollars.should_not eq(Money.new(30.0, "USD"))
    end

    it "is equal after converted" do
      fifty_eur = Money.new(50.0, "EUR")
      fifty_eur.convert_to("USD").amount.should be_close(Money.new(55.50, "USD").amount, 0.01)
    end
  end

  describe "greater than" do
    it "does return true" do
      result = Money.new(20.0, "USD") > Money.new(5.0, "USD")
      result.should be_truthy
    end

    it "does return false" do
      result = Money.new(5.0, "USD") > Money.new(20.0, "USD")
      result.should be_falsey
    end
  end

  describe "greater than or equal" do
    it "does return true when greater" do
      result = Money.new(20.0, "USD") >= Money.new(15.0, "USD")
      result.should be_truthy
    end

    it "does return true when equal" do
      result = Money.new(20.0, "USD") >= Money.new(20.0, "USD")
      result.should be_truthy
    end
  end

  describe "lower than" do
    it "does return true" do
      result = Money.new(5.0, "USD") < Money.new(20.0, "USD")
      result.should be_truthy
    end

    it "does return false" do
      result = Money.new(20.0, "USD") < Money.new(5.0, "USD")
      result.should be_falsey
    end
  end

  describe "lower than or equal" do
    it "does return true when lower" do
      result = Money.new(15.0, "USD") <= Money.new(20.0, "USD")
      result.should be_truthy
    end

    it "does return true when equal" do
      result = Money.new(20.0, "USD") <= Money.new(20.0, "USD")
      result.should be_truthy
    end
  end
end
