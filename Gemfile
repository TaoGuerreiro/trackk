# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem 'rails', '~> 7.0.5'

gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'devise'
gem 'discordrb'
gem 'google-api-client', require: 'google/apis/calendar_v3'
gem 'jsbundling-rails'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'redis', '~> 4.0'
gem 'sidekiq'
gem 'sidekiq-failures', '~> 1.0'
gem 'simple_form'
gem 'simple_form-tailwind'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
end

group :development do
  gem 'web-console'
end
