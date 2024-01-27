# frozen_string_literal: true

source 'https://rubygems.org'

gem 'hanami', '~> 1.3'
gem 'hanami-model', '~> 1.3'
gem 'rake'

gem 'faraday', '~> 2.9'
gem 'faraday-http-cache', '~> 2.5', '>= 2.5.1'
gem 'filecache', '~> 1.0', '>= 1.0.3'
gem 'sqlite3'

gem 'rubocop', require: false

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'hanami-webconsole'
  gem 'shotgun', platforms: :ruby
end

group :test, :development do
  gem 'dotenv', '~> 2.4'
  gem 'simplecov', require: false
end

group :test do
  gem 'capybara'
  gem 'rspec'
end

group :production do
  # gem 'puma'
end
