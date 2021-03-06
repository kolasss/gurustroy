source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'rails-api'
gem 'pg'
gem 'annotate' # ruby model annotations

# Pagination
gem 'kaminari'

# File upload
gem 'carrierwave'
gem 'mini_magick'

# To use Jbuilder templates for JSON
gem 'jbuilder'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :development do
  gem 'guard' # auto testing
  gem 'guard-minitest'

  # ruby deployment system
  gem "capistrano", "~> 3.4"
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-passenger'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-bundler', '~> 1.1.2'
end

group :test do
  gem 'minitest-reporters' # for better test reports in console
  gem 'simplecov', :require => false # reports about coverage
  gem 'webmock' #mocking web requests
end

gem 'pundit' # authorization
gem 'jwt' # JSON Web Token

gem 'pg_search' # PostgreSQL's full text search.
gem 'file_validators' # file size validator
gem 'phony_rails' # phone validations
