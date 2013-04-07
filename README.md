# JRubyCurses

Partial implementation of the Ruby curses library developed to run with 
jRuby and Java/Swing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jruby_curses'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install jruby_curses
```

## Usage

```ruby
require 'curses'
```
   
Then use the curses' APIs with the hope it is implemented...

The gem name is "jruby_curses" but the client code requires "curses" so 
that it can the code is compatible with RMI native curses.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
