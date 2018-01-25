source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
gem 'rails-i18n', '~> 5.0.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.21'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Back
gem 'attachinary', github: 'Cookoon/attachinary'
gem 'devise'
gem 'devise-i18n'
gem 'devise_invitable', '~> 1.7.0'
gem 'figaro'
gem 'geocoder'
gem 'money-rails', '~>1'
gem 'pundit'
gem 'rack-cors', require: 'rack/cors'
gem 'simple_scheduler'

# Front
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'gmaps4rails'
gem 'hammerjs-rails'
gem 'icalendar'
gem 'jquery-fileupload-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'momentjs-rails', '>= 2.9.0'
gem 'roadie-rails'
gem 'sidekiq'
gem 'sidekiq-failures', '~> 1.0'
gem 'simple_form'
gem 'slim'

source 'https://rails-assets.org' do
  gem 'rails-assets-smalot-bootstrap-datetimepicker'
  gem 'rails-assets-underscore'
end

# Admin
gem 'forest_liana'
gem 'pretender'

# External
gem 'cloudinary'
gem 'postmark-rails'
gem 'ruby-trello'
gem 'stripe'

# Tracking
gem 'raygun4ruby'
gem 'scout_apm'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Custom
  gem 'bullet'
  gem 'i18n-debug'
  gem 'letter_opener'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop', '~> 0.52', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
