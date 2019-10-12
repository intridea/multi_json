# coding: utf-8
require File.expand_path("../lib/multi_json/version.rb", __FILE__)

Gem::Specification.new do |spec|
  spec.authors       = ["Michael Bleigh", "Josh Kalderimis", "Erik Michaels-Ober", "Pavel Pravosud"]
  spec.email         = %w[michael@intridea.com josh.kalderimis@gmail.com sferik@gmail.com pavel@pravosud.com]
  spec.cert_chain    = %w[certs/rwz.pem]
  spec.summary       = "A common interface to multiple JSON libraries."
  spec.description   = "A common interface to multiple JSON libraries, including Oj, Yajl, the JSON gem (with C-extensions), the pure-Ruby JSON gem, NSJSONSerialization, gson.rb, JrJackson, and OkJson."
  spec.files         = Dir["*.md", "lib/**/*"]
  spec.homepage      = "http://github.com/intridea/multi_json"
  spec.license       = "MIT"
  spec.name          = "multi_json"
  spec.require_path  = "lib"
  spec.signing_key   = File.expand_path("~/.ssh/gem-private_key.pem") if $PROGRAM_NAME =~ /gem\z/
  spec.version       = MultiJson::Version

  spec.required_rubygems_version = ">= 1.3.5"
  spec.add_development_dependency "rake", "~> 10.5"
  spec.add_development_dependency "rspec", "~> 3.9"
end