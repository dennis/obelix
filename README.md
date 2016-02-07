# Obelix

[![Build Status](https://travis-ci.org/dennis/obelix.svg?branch=develop)](https://travis-ci.org/dennis/obelix)
[![Code Climate](https://codeclimate.com/github/dennis/obelix/badges/gpa.svg)](https://codeclimate.com/github/dennis/obelix)

Asterisk client library for AMI communication.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'obelix'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install obelix

## Usage

This gem is still under heavy development. So API might (and will) change.

```ruby
ami = Obelix::AMI.client('localhost:5038')

ami.login!("web", "web")

ami.database_put!("test", "key", Time.now.to_s)
ami.database_put!("test", "key2", "42")
ami.database_show!.each do |family, key, value|
  puts "family=#{family}, key=#{key}, value=#{value}"
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dennis/obelix

## License

This gem is created by Dennis Møllegaard Pedersen and is under the terms of [MIT License](http://opensource.org/licenses/MIT).

