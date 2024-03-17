require File.expand_path("lib/multi_json/version.rb", __dir__)

Gem::Specification.new do |spec|
  spec.authors = ["Michael Bleigh", "Josh Kalderimis", "Erik Berlin", "Pavel Pravosud"]
  spec.description = "A common interface to multiple JSON libraries, including Oj, Yajl, the JSON gem (with C-extensions), the pure-Ruby JSON gem, gson, JrJackson, and OkJson."
  spec.email = %w[michael@intridea.com josh.kalderimis@gmail.com sferik@gmail.com pavel@pravosud.com]
  spec.files = Dir["*.md", "lib/**/*"]
  spec.homepage = "https://github.com/intridea/multi_json"
  spec.license = "MIT"
  spec.name = "multi_json"
  spec.require_path = "lib"
  spec.required_ruby_version = ">= 3.0"
  spec.summary = "A common interface to multiple JSON libraries."
  spec.version = MultiJson::Version

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/intridea/multi_json/issues",
    "changelog_uri" => "https://github.com/intridea/multi_json/blob/v#{spec.version}/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/multi_json/#{spec.version}",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/intridea/multi_json/tree/v#{spec.version}",
    "wiki_uri" => "https://github.com/intridea/multi_json/wiki"
  }
end
