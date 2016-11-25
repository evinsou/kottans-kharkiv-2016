# frozen_string_literal: true
source "https://rubygems.org"

ruby '2.2.5'

gem "sinatra"
gem "activerecord"
gem "sinatra-activerecord"
gem 'sinatra-flash'
gem 'aescrypt'
gem 'pg'

group :development do
  gem 'byebug'
  gem "tux"

end

group :development, :test do
  gem "rspec"
  gem 'rack'
  gem "rack-test"
  gem 'guard'
  gem 'guard-rspec'
  gem 'foreman'
  gem 'factory_girl'
  gem 'database_cleaner'
  gem 'rspec-timecop'
  gem 'capybara'
end

group :production do
end
