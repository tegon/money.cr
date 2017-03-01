# money

Currency conversion library

[![Build Status](https://travis-ci.org/tegon/money.cr.svg?branch=master)](https://travis-ci.org/tegon/money.cr)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  money:
    github: tegon/money
```

# Usage
---

```crystal
require "money"
```

### Configuration

First you have to configure the base currency and conversion rates.

```crystal
Money.conversion_rates(String, Hash of String => Float64)
```

#### Example

```crystal
Money.conversion_rates("BRL", { "USD" => 3.12, "EUR" => 3.34 })
```

### Constructor

The constructor accepts two arguments, the amount and the currency:

```crystal
money = Money.new(Float64, String)
```

#### Example

```crystal
money = Money.new(50, "BRL")
money = Money.new(55.50, "BRL")
```

# Methods
---

### #convert_to

This method returns a new `Money` instance with the currency passed as argument.

```crystal
new_money = money.convert_to(String)
```

#### Example

```crystal
new_money = money.convert_to("USD")
=> "156.00 USD"
```

If you pass an unknown currency, you"ll get a error:

```crystal
new_money = money.convert_to("CAD")
=> "Money::ConversionRateMissingError: Missing conversion rate for currency: CAD. Please set it using Money.conversion_rates"
```

The following arithmetic operations are supported:

### Sum

```crystal
sum = money + other_money
```

#### Example

```crystal
sum = Money.new(10, "BRL") + Money.new(50, "BRL")
=> "60.00 BRL"
sum = Money.new(10, "BRL") + Money.new(50, "USD")
=> "166.00 BRL"
```

### Subtraction

```crystal
subtraction = money - other_money
```

#### Example

```crystal
subtraction = Money.new(50, "BRL") - Money.new(10, "BRL")
=> "40.00 BRL"
subtraction = Money.new(200, "BRL") - Money.new(50, "USD")
=> "44.00 BRL"
```

### Division

```crystal
division = money / Float64 | Int32
```

#### Example

```crystal
division = Money.new(50, "BRL") / 2
=> "25.00 BRL"
```

### Multiplication

```crystal
multiplication = money * Float64 | Int32
```

#### Example

```crystal
multiplication = Money.new(50, "BRL") * 2
=> "100.00 BRL"
```

### Comparisons

The comparisons are based on the money result. If a different currencies are used, the one on the right will be converted.


#### Example

```crystal
Money.new(156, "BRL") == Money.new(156, "BRL") # same amount, same currency, returns true
=> true
Money.new(156, "BRL") == Money.new(50, "USD") # different amount and currency, but 50 USD converted to BRL is 156, the result is true
=> true
Money.new(50, "BRL") == Money.new(156, "BRL") # same currency, different amount, returns false
=> false
Money.new(50, "BRL") == Money.new(50, "USD") # same currency, same amount, returns false (1 USD is 3.12 BRL)
=> false
Money.new(50, "USD") > Money.new(50, "BRL") # 50 USD is 156 BRL
=> true
Money.new(50, "USD") < Money.new(50, "BRL") # 50 USD is 156 BRL
=> false
```

# Development

You need crystal version 0.18.7 or newer installed. After you've installed it, clone the repository with:

```bash
git clone https://github.com/tegon/money.cr
```

Then run the test suite to make sure everything is working correctly:

```bash
cd money
crystal spec
```

# Contributing

1. Fork it ( https://github.com/tegon/money.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
