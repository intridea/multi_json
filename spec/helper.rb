unless ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

require 'multi_json'
require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def macruby?
  defined?(RUBY_ENGINE) && RUBY_ENGINE == 'macruby'
end

class MockDecoder
  def self.load(string, options={})
    {'abc' => 'def'}
  end

  def self.dump(string)
    '{"abc":"def"}'
  end
end

class TimeWithZone
  def to_json(options={})
    "\"2005-02-01T15:15:10Z\""
  end
end
