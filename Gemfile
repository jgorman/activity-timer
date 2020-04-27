# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.5"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.1"

# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"

# Use mysql as the database for Active Record
gem "mysql2", ">= 0.4.4"

# Use Puma as the app server
gem "puma", "~> 4.3"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"
# Turbolinks makes navigating your web application faster.
# Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem "devise"
# gem 'omniauth' # https://github.com/advisories/GHSA-ww4x-rwq6-qpgf
gem "envyable"
gem "faker"
gem "octicons_helper"
gem "turbolinks_render"

group :development, :test do
  # Call 'byebug' anywhere to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "erb_lint"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console'.
  gem "better_errors"
  gem "binding_of_caller"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"

  # npm install -g @prettier/plugin-ruby
  gem "htmlbeautifier"
  gem "rubocop-rails_config"

  gem "capistrano", "~> 3.11"
  gem "capistrano-passenger", "~> 0.2.0"
  gem "capistrano-rails", "~> 1.4"
  gem "capistrano-rbenv", "~> 2.1"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
