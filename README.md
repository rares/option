# Option

A Ruby port os Scala's Option monad. Tries to be faithful
but also pragmatic in RE: to ducktyping.

## Installation

Add this line to your application's Gemfile:

    gem 'option'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install option

## Usage

Generally, you want to use the Option(A) wrapper method to box
your value. This will make the right decision as to what your initial
value should be:

```ruby
foo = Option("bar")
```

This will allow you to now manipulate the value in the box via various means:

```ruby

# get the value
foo.get #=> "bar"

# return a default if the box is None
None.get_or_else { "default" } #=> "default"

# map the value to another option
foo.map { |v| v.upcase } #=> Some("BAR")

# does the value meet a requirement?
foo.exists? { |v| v == "bar" } #=> true

# return the value or nil depending on the state
foo.or_nil #=> "bar"

# chain values
foo.map { |v| v * 2 }.map { |v| v.upcase }.get_or_else { "missing" } #=> BARBAR

# attempt to extract a value but default if None
None.fold(-> { "missing" }) { |v| v.upcase } #=> missing
```

## Build Status
<a href="http://travis-ci.org/rares/option">![http://travis-ci.org/rares/option](https://secure.travis-ci.org/rares/option.png)</a>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
