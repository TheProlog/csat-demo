source 'https://rubygems.org'
source 'https://rails-assets.org'

gem 'rails', '3.2.16'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'quiet_assets'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails' #,   '~> 3.2.3'
  gem 'coffee-rails' #,, '~> 3.2.1'
  gem 'rails-assets-bootstrap'
  gem 'rails-assets-sugar'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier' #, '>= 1.0.3'
end

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rspec-html-matchers'
  gem 'rspec-http'
  gem 'tapout'
  gem 'teaspoon'
  gem 'pry'
  gem 'pry-rails'
  gem 'selenium-webdriver'
end

group :development do
  gem 'rubocop'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara'
end

gem 'haml-rails'
gem 'jquery-rails'
gem 'thin'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
