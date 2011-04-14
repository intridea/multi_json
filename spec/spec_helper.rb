begin
  require 'bundler'
rescue LoadError
  puts "although not required, it's recommended that you use bundler during development"
end

require 'multi_json'
require 'rspec'
require 'rspec/autorun'
