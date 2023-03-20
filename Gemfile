source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.4', '>= 1.4.6'
# PgSearch builds Active Record named scopes that take advantage of PostgreSQL's full text search
gem 'pg_search', '~> 2.3', '>= 2.3.6'
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

# Autoload dotenv in Rails.
gem 'dotenv-rails', '~> 2.8', '>= 2.8.1'

# Upload files in your Ruby applications, map them to a range of ORMs, store them on different backends.
gem 'carrierwave', '~> 2.2', '>= 2.2.3'

# This gem can be useful, if you need to upload files to your API from mobile devises.
gem 'carrierwave-base64', '~> 2.10'

# Kaminari is a Scope & Engine based, clean, powerful, agnostic, customizable and sophisticated paginator
gem 'kaminari', '~> 1.2', '>= 1.2.2'

# Object oriented authorization for Rails applications
gem 'pundit', '~> 2.3'

# This library provides integration of RubyMoney - Money gem with Rails
gem 'money-rails', '~> 1.15'

# Stripe is the easiest way to accept payments online. See https://stripe.com for details.
gem 'stripe', '~> 8.3'

# The fastest JSON parser and object serialize
# r.
gem 'oj', '~> 3.14', '>= 3.14.2'

# Middleware that will make Rack-based apps CORS compatible.
gem 'rack-cors', '~> 2.0', '>= 2.0.1', :require => 'rack/cors'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  # rspec-rails is a testing framework for Rails 5+.
  gem 'rspec-rails', '~> 6.0', '>= 6.0.1'
  # provides integration between factory_bot and rails 5.0 or newer
  gem 'factory_bot_rails', '~> 6.2'
  # Record your test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests.
  gem 'vcr'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"
  # Makes spring watch files using the listen gem.
  gem 'spring-watcher-listen', '~> 2.1'
 end

group :test do
  # Shoulda Matchers provides RSpec- and Minitest-compatible one-liners to test common Rails functionality
  gem 'shoulda-matchers', '~> 5.3'
  # WebMock allows stubbing HTTP requests and setting expectations on HTTP requests.
  gem 'webmock', '~> 3.18', '>= 3.18.1'
  # Strategies for cleaning databases. Can be used to ensure a clean slate for testing.
  gem 'database_cleaner', '~> 2.0', '>= 2.0.2'
end
