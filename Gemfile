# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

gem 'bcrypt', '~> 3.1.13'
gem 'puma', '~> 6.0'
gem 'rails', '~> 6.1.6', '>= 6.1.6.1'
gem 'sqlite3', '~> 1.4', '= 1.4.2'

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
gem 'dotenv', '~> 2.7'
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
gem 'sidekiq', '~> 7'
# для проверки корректности введенного email
gem 'valid_email2', '~> 4.0'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker', '~> 3'
  gem 'pry-rails'
  gem 'pundit-matchers', '~> 1.7.0'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '>= 5.1.2'
end

gem 'faraday', '~> 2.5'
gem 'foreman', '~> 0.87.2'
gem 'json', '~> 2.6', '>= 2.6.2'

group :test do
  gem 'rspec', '~> 3.11'
  gem 'vcr', '~> 6.1'
  gem 'webmock', '~> 3.14'
end

group :development do
  # Чтобы искать неоптимальные запросы и их устранять используется решение «bullet»
  gem 'bullet', '~> 7'
  # Решение, которое позволит тестировать отправку писем в локальной среде без почтового сервера
  gem 'letter_opener'
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 3.0'
  gem 'rubocop', '~> 1.30', require: false
  gem 'rubocop-performance', '~> 1.14', require: false
  gem 'rubocop-rails', '~> 2.14', require: false
  gem 'rubocop-rspec', require: false
  gem 'web-console', '>= 4.1.0'
end

# Gemfile (очистить базу данных)
# https://github.com/DatabaseCleaner/database_cleaner
group :test do
  gem 'database_cleaner-active_record'
end

gem 'cssbundling-rails', '~> 1.0'
gem 'jsbundling-rails', '~> 1.0'
gem 'sprockets-rails', '~> 3.4'
