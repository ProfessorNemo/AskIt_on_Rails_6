# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    before_action :require_authentication
    before_action :set_user!, only: %i[edit update destroy]
    before_action :authorize_user!
    after_action :verify_authorized

    # вытащим всех юзеров и разобъем их по страницам
    def index
      # научим наше приложение правильно отвечать на разные форматы запрошенные
      respond_to do |format|
        # описываем те форматы, на которые мы хотим отвечать
        format.html do
          @pagy, @users = pagy User.order(created_at: :desc)
          # render по умолчанию
        end

        format.zip do
          UserBulkExportJob.perform_later current_user
          # Задача поставлена в очередь на выполнение. Как только она завершится,
          # вы получите уведомление на email
          flash[:success] = t '.success'
          redirect_to admin_users_path
        end
      end
    end

    # открыть файл zip, вытащить оттуда файлы excel, каждый из низ обработать
    # и на основе него создать столько пользователей, сколько нужно с учетом валидаций.

    # Проверить, был ли передан архив. Если да, вызываем сервисный класс "UserBulkService",
    # передаем ему архив "params[:archive]".
    def create
      if params[:archive].present?
        # UserBulkService.call params[:archive]
        #
        # Вместо вызова сервисного объекта с параметром "архив".
        # perform_later - поставить задачу в очередь и сделать в фоне
        # current_user - юзер, который инициировал задачу, и именно на его почту
        # будет выслана инфа о выполнении задачи
        UserBulkImportJob.perform_later create_blob, current_user
        flash[:success] = t('.success')
      end

      redirect_to admin_users_path
    end

    def edit; end

    def update
      # @user.admin_edit = true - только в админском контроллере
      if @user.update user_params
        flash[:success] = t '.success'
        redirect_to admin_users_path
      else
        render :edit
      end
    end

    def destroy
      @user.destroy
      flash[:success] = t '.success'
      redirect_to admin_users_path
    end

    private

    # создать новый файл в ActiveStorage
    def create_blob
      # открыть присланный временный файл
      file = File.open params[:archive]
      # "io" - input/output - содержимое файла, а в качестве имени файла - оригинальное имя архива
      result = ActiveStorage::Blob.create_and_upload! io: file,
                                                      filename: params[:archive].original_filename
      file.close
      # Вернем "key" - уникальный идентификатор загруженного файла в ActiveStorage. Этот ключ
      # будет храниться в одной из созданных таблиц
      result.key
    end

    # найти юзера, которого есть желание отредактировать
    def set_user!
      @user = User.find params[:id]
    end

    # то, что мы хотим разрешить изменять в админке
    def user_params
      params.require(:user).permit(
        :email, :name, :password, :password_confirmation, :role, :status
      ).merge(admin_edit: true)
    end

    # м-д "authorize" возьмется из базового контроллера "BaseController"
    def authorize_user!
      # с наследованием
      authorize(@user || User)
      # без наследования
      # authorize([:admin, (@user || User)])
    end
  end
end

# Или в методе "update":
# @user.admin_edit = true - (только в админском контроллере)
# Или в методе "user_params":
# ".merge(admin_edit: true)" - (только в админском контроллере)
