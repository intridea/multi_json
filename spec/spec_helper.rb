$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'multi_json'
require 'spec'
require 'spec/autorun'
require 'rubygems'
begin
  require 'bundler'
  Bundler.setup
rescue LoadError
  $stderr.puts "Bundler (or a dependency) not available."
end

Spec::Runner.configure do |config|
  
end
