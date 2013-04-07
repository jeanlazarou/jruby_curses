# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jruby_curses/version'

Gem::Specification.new do |gem|
  gem.name          = "jruby_curses"
  gem.version       = JRubyCurses::VERSION
  gem.authors       = ["Jean Lazarou"]
  gem.email         = ["jean.lazarou@alef1.org"]
  gem.description   = %q{Partial curses library for jRuby}
  gem.summary       = %q{Partial implementation of the Ruby curses library developed to run with jRuby and Java/Swing.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.platform = 'java'
end
