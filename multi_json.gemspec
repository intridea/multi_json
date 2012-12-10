# encoding: utf-8
require File.expand_path("../lib/multi_json/version", __FILE__)

Gem::Specification.new do |spec|
  spec.add_development_dependency 'rake', '>= 0.9'
  spec.add_development_dependency 'rspec', '>= 2.6'
  spec.add_development_dependency 'kramdown', '>= 0.14'
  spec.add_development_dependency 'simplecov', '>= 0.4'
  spec.add_development_dependency 'yard', '>= 0.8'
  spec.authors = ["Michael Bleigh", "Josh Kalderimis", "Erik Michaels-Ober"]
  spec.description = %q{A gem to provide easy switching between different JSON backends, including Oj, Yajl, the JSON gem (with C-extensions), the pure-Ruby JSON gem, and OkJson.}
  spec.email = ['michael@intridea.com', 'josh.kalderimis@gmail.com', 'sferik@gmail.com']
  spec.files = Dir['.yardopts', 'CHANGELOG.md', 'CONTRIBUTING.md', 'LICENSE.md', 'README.md', 'Rakefile', 'multi_json.gemspec', 'Gemfile', '.document', '.rspec', '.travis.yml' ,'spec/**/*', 'lib/**/*']
  spec.homepage = 'http://github.com/intridea/multi_json'
  spec.licenses = ['MIT']
  spec.name = 'multi_json'
  spec.require_paths = ['lib']
  spec.required_rubygems_version = Gem::Requirement.new(">= 1.3.6")
  spec.summary = %q{A gem to provide swappable JSON backends.}
  spec.test_files = Dir['spec/**/*']
  spec.version = MultiJson::VERSION
end
