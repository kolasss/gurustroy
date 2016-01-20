source 'https://rubygems.org'

gem 'rails', '4.2.5'
gem 'rails-api'
gem 'pg'
gem 'annotate' # ruby model annotations
gem 'thin' # web server

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
end

group :test do
  gem 'minitest-reporters' # for better test reports in console
  # gem 'mini_backtrace'
  # gem 'webmock' #mocking web requests
  gem 'simplecov', :require => false # reports about coverage
end

gem 'pundit' # authorization
gem 'jwt' # JSON Web Token

gem 'pg_search' #PostgreSQL's full text search.
gem 'file_validators' # file size validator
