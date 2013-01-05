source 'https://rubygems.org'

gem 'json',      '~> 1.4', :require => nil
platforms :ruby, :mswin, :mingw do
  gem 'oj',        '>= 1.4.7', '< 3.0', :require => nil
  gem 'yajl-ruby', '~> 1.0', :require => nil
end
platforms :jruby do
  gem 'gson', '>= 0.6', :require => nil
end

gemspec
