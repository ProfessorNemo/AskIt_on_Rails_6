# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.6', '>= 6.1.6.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4', '= 1.4.2'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 6.0.0-rc.6'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.13'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Позволяет импортировать множество записей за один запрос
# https://github.com/zdennis/activerecord-import
gem 'activerecord-import', '~> 1.4'
# Сериализатор - это программный код, с помощью которого объекты ruby превращаются
# в json. Сериализатор работает быстрее, чем 'jbuilder', '~> 2.11'
gem 'blueprinter'
# решение, помогающие создавать файлы xlxs, но не умеет считывать
gem 'caxlsx', '~> 3.2'
# решение, помогающие правильным образом работать с представлениями
gem 'caxlsx_rails', '~> 0.6'
# решение, которое позволяет загружать дополнительную конфигурацию из файлов .env
gem 'dotenv-rails', '~> 2.7'
# декораторы
gem 'draper', '~> 4.0'
# гемы для разбиения по страничкам
gem 'pagy', '~> 5.10'
# описывает то ,что могут делать юзеры в зависимости от их роли
# https://github.com/varvet/pundit
gem 'pundit', '~> 2.2'
# для подгрузки в приложение типичных переводов (месяцы, дни недели, валюты и т.д.)
gem 'rails-i18n', '~> 7.0.3'
# позволяет работать с XLSX, считывать и модифицировать
gem 'rubyXL', '~> 3.4'
# решение, которое позволяет работать с архивами .zip
gem 'rubyzip', '~> 2.3'
# адаптер для выполнения задач в фоновом режиме
gem 'sidekiq', '~> 6.5'
# для проверки корректности введенного email
gem 'valid_email2', '~> 4.0'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'faker', '~> 2'
  gem 'pry-rails'
end

group :development do
  # Чтобы искать неоптимальные запросы и их устранять используется решение «bullet»
  gem 'bullet', '~> 7'
  # Решение, которое позволит тестировать отправку писем в локальной среде без почтового сервера
  gem 'letter_opener'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 3.0'
  gem 'rubocop', '~> 1.30', require: false
  gem 'rubocop-performance', '~> 1.14', require: false
  gem 'rubocop-rails', '~> 2.14', require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Gemfile (очистить базу данных)
# https://github.com/DatabaseCleaner/database_cleaner
group :test do
  gem 'database_cleaner-active_record'
end
