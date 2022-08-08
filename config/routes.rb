# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :tags, only: :index
  end

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    resource :session, only: %i[new create destroy]

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

    root 'pages#index'
  end
end
