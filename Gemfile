source 'https://rubygems.org'

gem 'rails', '~> 5.1.2'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'

gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'health_check'
gem 'sidekiq'
gem "sidekiq-cron", "~> 0.4.0"
gem 'figaro'
gem 'aws-sdk'
gem 'geocoder'
gem 'rest-client'
gem 'rerun'
gem 'celluloid'
gem 'sidekiq-throttled'
gem 'jquery'
gem 'bootstrap', '~> 4.0.0.alpha6'
gem "lograge"
gem 'devise'
gem 'google-cloud-vision'
gem 'acts-as-taggable-on', github: 'mbleigh/acts-as-taggable-on'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :production do
  gem 'therubyracer', platforms: :ruby
end

group :development do
  gem 'foreman'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
