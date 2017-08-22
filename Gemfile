source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.3'

gem 'browser'
gem 'cancancan'
gem 'coffee-rails', '~> 4.2'
gem 'dalli'
gem 'devise', '>= 4.2'
gem 'default_value_for'
gem 'friendly_id'
gem 'font-awesome-rails'
gem 'maruku'
gem 'omniauth-google-oauth2'
gem 'omniauth-oauth2', '~> 1.3.1'

gem 'pg'
gem 'prawn'
gem 'puma'
gem 'responders'
gem 'rubyzip', require: 'zip'
gem 'sassc-rails' # , '~> 5.0'
gem 'slim-rails'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  # gem 'capybara', '~> 2.13'
  # gem 'selenium-webdriver'
  gem 'dotenv-rails', require: 'dotenv/rails-now'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  # gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby '2.4.1'
