# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.1.3'
# Use Puma as the app server
gem 'puma', '>= 4.3.9'
# Asset pipeline and Hotwire (propshaft + importmap + Turbo/Stimulus)
gem 'propshaft'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'

gem 'trilogy'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'         ## Commented out by Mullzk. Mensajasser is HTML only.
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
group :development do
  gem 'capistrano', '~> 3.20'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  # Required by net-ssh to authenticate with ED25519 SSH keys.
  # Symptom shows up in clean environments (GitHub Actions runner, fresh
  # containers) where the deploy key is the only identity available — net-ssh
  # cannot use the ED25519 key without these gems and auth fails.
  # Locally cap deploy may succeed even without them, e.g. when ssh-agent
  # holds additional keys or ~/.ssh/config provides fallbacks; the failure
  # mode is masked.
  gem 'ed25519', '~> 1.2'
  gem 'bcrypt_pbkdf', '~> 1.0'
end

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Gems for this project, added by mullzk
gem 'will_paginate'

group :development, :test do
  gem 'factory_bot_rails', '~> 6.5'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails' 
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.11'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  # Selenium 4.11+ manages browser drivers itself via Selenium Manager;
  # the separate 'webdrivers' gem is no longer needed.
  gem 'selenium-webdriver', '>= 4.11'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'bundle-audit', '~> 0.2.0'

gem 'rubocop', '~> 1.87'

gem 'brakeman', '~> 8.0'

gem "annotate"

gem "ostruct", "~> 0.6.1"
