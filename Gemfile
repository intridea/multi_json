source "https://rubygems.org"

gem "json", "~> 2.0", require: false
gem "json_pure", "~> 2.0", require: false

gem "rake", ">= 13.1"
gem "rspec", ">= 3.13"
gem "rubocop", ">= 1.62.1"
gem "rubocop-performance", ">= 1.20.2"
gem "rubocop-rake", ">= 0.6.0"
gem "rubocop-rspec", ">= 2.27.1"
gem "standard", ">= 1.35.1"

if RUBY_DESCRIPTION.start_with?("jruby")
  gem "gson", ">= 0.6", require: false
else
  gem "oj", "~> 3.0", require: false
  gem "yajl-ruby", "~> 1.3", require: false
end

gemspec
