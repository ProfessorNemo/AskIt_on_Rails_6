# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: :destroy
  before_action :set_user, only: :create

  def new; end

  def create
    if @user&.authenticate(params[:password])
      do_sign_in @user
      # flash[:success] = "Welcome back, #{current_user.name_or_email}!"
      flash[:success] = t('.success', name: current_user.name_or_email)
      redirect_to root_path
    else
      # flash[:warning] = 'Incorrect email and/or password!'
      # redirect_to session_path
      # или
      flash.now[:warning] = t '.invalid_creds'
      render :new
    end
  end

  def destroy
    sign_out
    flash[:success] = t '.success'
    redirect_to root_path
  end

  private

  def set_user
    # render plain: params.to_yaml and return
    # НЕ "@user", а "user", потому что в представлениях фигурировать не будет
    # authenticate - метод из "has_secure_password" в модели "user". Данный метод принимает строку
    # конвертирует ее в хэш и сверяет с тем хэшем, который есть в БД.
    @user = User.find_by email: params[:email]
  end

  def do_sign_in(user)
    # пускаем юзера в систему
    sign_in user
    # запомнить пользователя, если он того хочет
    remember(user) if params[:remember_me] == '1'
  end
end
