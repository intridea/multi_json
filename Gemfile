source "https://rubygems.org"

gem "json", "~> 2.0", require: false
gem "json_pure", "~> 2.0", require: false

if RUBY_DESCRIPTION.start_with?("jruby")
  gem "gson", ">= 0.6", require: false
else
  gem "oj", "~> 3.0", require: false
  gem "yajl-ruby", "~> 1.3", require: false
end

gemspec
