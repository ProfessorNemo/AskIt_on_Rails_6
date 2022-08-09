# frozen_string_literal: true

require 'sidekiq/web'

# класс "Ограничение". М-д "matches" принимает запрос, который был отправлен
# на адрес '/sidekiq'. Приходит на этот адрес запрос, перенаправлем в AdminConstraint
# проверку, читаем запрос, смотрим, от кого он и решаем: пускать или нет.
# "user_id" - помещен либо в сессию, либо в зашифрованные куки если юзер поставил галочку
# "запомнить меня" (см. authentication.rb)
# request.cookie_jar.encrypted[:user_id] - дешифровка куки
class AdminConstraint
  def matches?(request)
    user_id = request.session[:user_id] || request.cookie_jar.encrypted[:user_id]

    # является ли найденный юзер админом (если юзер найден)
    User.find_by(id: user_id)&.admin_role?
  end
end

Rails.application.routes.draw do
  # Смонтировать маршрут Sidekiq::Web , по какому адресу он будет доступен ('/sidekiq'),
  # т.е. подрубаем интерфейс sidekiq по адресу '/sidekiq' (http://127.0.0.1:3000/sidekiq)
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

  namespace :api do
    resources :tags, only: :index
  end

  # например localhost/ru/questions, localhost/en/questions, localhost/questions
  # locale: /#{I18n.available_locales.join("|")}/ - проверка, что запрошенная локаль входит
  # в массив %i[en ru], а ("|") - "или" (локаль или такая, или такая.....)
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    resource :session, only: %i[new create destroy]

    # маршрут для сброса пароля (resource без s, т.к. не будем работать с id юзера)
    # new create - запросить инструкции для сброса пароля, edit update - сбросить
    resource :password_reset, only: %i[new create edit update]

    resources :users, only: %i[new create edit update]

    resources :questions do
      resources :answers, except: %i[new show]

      resources :comments, only: %i[create destroy]
    end

    resources :answers, except: %i[new show] do
      resources :comments, only: %i[create destroy]
    end

    namespace :admin do
      resources :users, except: %i[new]
    end

    # корневой маршрут
    root 'pages#index'
  end
end

# create - будет проверять корректность введенных данных и пускать пользователя в систему
# new - отображать форму для входа
# destroy - позволить юзерам из системы выходить
# при входе юзера в систему он создает новую сессия
# Если хотим, чтоб не было никаких идентификаторов в маршрутах, пишем
# "resource" а не "resources"

# не нужен маршрут "new", потому что форма рендериться на другой странице
# и "show", поскольку не нужно показывать каждый вопрос на отдельной странице
# resources :questions, only: %i[index new edit create update destroy show]

# контроллер "questions" должен обрабатывать методом - "index"
# Я хотел бы, чтобы при заходе на мой сайт пользователи писали к примеру "localhost/questions"
# в своей адресной строке браузера. Нажатие enter и отправляется GEt запрос. Поэтому, как только придет
# # GEt-запрос с адресом /questions, тогда направляй его на контроллер "questions"
# get '/questions', to: 'questions#index'

# # маршрут к созданию нового вопроса пользователем и метод "new"
# get '/questions/new', to: 'questions#new'

# # :id - переменная поля (идентификатор вопроса), edit - редактир.запись
# get '/questions/:id/edit', to: 'questions#edit'

# # маршрут к месту создания вопроса
# post '/questions', to: 'questions#create'
