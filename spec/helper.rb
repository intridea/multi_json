def macruby?
  defined?(RUBY_ENGINE) && RUBY_ENGINE == 'macruby'
end

require 'simplecov'
SimpleCov.start unless macruby?
require 'multi_json'
require 'rspec'

class MockDecoder
  def self.decode(string, options = {})
    {'abc' => 'def'}
  end

  def self.encode(string)
    '{"abc":"def"}'
  end
end

class TimeWithZone
  def to_json(options = {})
    "\"2005-02-01T15:15:10Z\""
  end
end

def yajl_on_travis(engine)
  ENV['TRAVIS'] && engine == 'yajl' && jruby?
end

def nsjsonserialization_on_other_than_macruby(engine)
  engine == 'nsjsonserialization' && !macruby?
end

def jruby?
  defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'
end
