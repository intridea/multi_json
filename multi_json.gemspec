# coding: utf-8
require File.expand_path("../lib/multi_json/version.rb", __FILE__)

Gem::Specification.new do |spec|
  spec.authors       = ["Michael Bleigh", "Josh Kalderimis", "Erik Michaels-Ober", "Pavel Pravosud"]
  spec.email         = %w[michael@intridea.com josh.kalderimis@gmail.com sferik@gmail.com pavel@pravosud.com]
  spec.summary       = "A common interface to multiple JSON libraries."
  spec.description   = "A common interface to multiple JSON libraries, including Oj, Yajl, the JSON gem (with C-extensions), the pure-Ruby JSON gem, NSJSONSerialization, gson.rb, JrJackson, and OkJson."
  spec.files         = Dir["*.md", "lib/**/*"]
  spec.homepage      = "https://github.com/intridea/multi_json"
  spec.license       = "MIT"
  spec.name          = "multi_json"
  spec.require_path  = "lib"
  spec.version       = MultiJson::Version

  spec.metadata = {
    'bug_tracker_uri'   => 'https://github.com/intridea/multi_json/issues',
    'changelog_uri'     => "https://github.com/intridea/multi_json/blob/v#{spec.version}/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/multi_json/#{spec.version}",
    'source_code_uri'   => "https://github.com/intridea/multi_json/tree/v#{spec.version}",
    'wiki_uri'          => 'https://github.com/intridea/multi_json/wiki'
  }

  spec.required_rubygems_version = ">= 1.3.5"
  spec.add_development_dependency "rake", "~> 10.5"
  spec.add_development_dependency "rspec", "~> 3.9"
end
