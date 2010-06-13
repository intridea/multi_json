$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'multi_json'
require 'spec'
require 'spec/autorun'
require 'rubygems'
require 'bundler'
Bundler.setup

Spec::Runner.configure do |config|
  
end
