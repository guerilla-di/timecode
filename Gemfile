source 'https://rubygems.org'

gem 'approximately', '~> 1.1'

group :development do
  if RUBY_VERSION < "1.9"
    gem "jeweler", '1.8.4' # Last one without the stupid nokogiri dependency
  else
    gem "jeweler"
  end
  
  gem "rake", '~> 10'
  gem 'git', '1.2.9.1'
  gem 'minitest'
end
