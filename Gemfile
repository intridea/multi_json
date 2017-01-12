source 'https://rubygems.org'

gem 'rake', '~> 10.5'
gem 'yard', '>= 0.8'

gem 'json',      '~> 2.0', :require => nil
gem 'json_pure', '~> 2.0', :require => nil

group :development do
  gem 'benchmark-ips'
  gem 'kramdown', '>= 0.14'
  gem 'pry'
end

group :test do
  gem 'rspec', '>= 2.14'
end

platforms :jruby do
  gem 'gson', '>= 0.6', :require => nil
  gem 'jrjackson', '~> 0.3.4', :require => nil
end

platforms :mingw, :mswin, :ruby do
  gem 'oj', '~> 2.18', :require => nil
  gem 'yajl-ruby', '~> 1.3', :require => nil
end

gemspec
