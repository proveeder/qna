source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# SMTH VERY NEEDED FOR PROD
gem 'listen', '~> 3.3'

# FRONT
gem 'jquery-rails'
gem 'slim-rails'

# AUTH
gem 'devise'

gem 'cancancan'

# OAUTH
gem 'omniauth'
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter2'

gem 'doorkeeper'

# FILES
gem 'carrierwave'
gem 'cocoon'

gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
gem 'responders'

# TASKS
gem 'sidekiq', '= 5.2.10'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'whenever'

# SPHINX SEARCH
gem 'jdbc-mysql',      '~> 5.1.35', platform: :jruby
gem 'mysql2',          '~> 0.4',    platform: :ruby
gem 'thinking-sphinx', '~> 5.4'

# DEPLOYMENT
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'
gem 'unicorn'
gem 'redis-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'rubocop'

  gem 'letter_opener'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # gem 'net-ssh', require: false
  # gem 'bcrypt_pbkdf'
  gem 'capistrano', require: false
  gem 'capistrano3-unicorn', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'ed25519', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'capybara-email'
  gem 'capybara-webkit', github: 'thoughtbot/capybara-webkit', branch: 'master'
  gem 'database_cleaner'
  gem 'json_spec'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
