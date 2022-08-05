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

        format.zip { respond_with_zipped_users }
      end
    end

    # открыть файл zip, вытащить оттуда файлы excel, каждый из низ обработать
    # и на основе него создать столько пользователей, сколько нужно с учетом валидаций.

    # Проверить, был ли передан архив. Если да, вызываем сервисный класс "UserBulkService",
    # передаем ему архив "params[:archive]".
    def create
      if params[:archive].present?
        UserBulkService.call params[:archive]
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

    def respond_with_zipped_users
      # Сгенерировать zip-файл, в котором будут находиться файлы Excel
      # OutputStream - архив, который мы будем пересылать юзеру в ответ на его запрос,
      # при этотом этот архив на диске у нас храниться не будет (временный архив).
      compressed_filestream = Zip::OutputStream.write_buffer do |zos|
        # Файлы будут создаваться для каждого юзера отдельно:
        User.order(created_at: :desc).each do |user|
          # Затем нам потребуется набрасывать в этот виртуальный архив какие-то файлы (записи).
          # Указываем после "zos.put_next_entry" имя файла, который хотим поместить в архив:
          zos.put_next_entry "user_#{user.id}.xlsx"
          # Сгенерировать excel-файл с помощью метода "render_to_string". Т.е. будем делать строку,
          # которую запишем с помощью "zos.print" в файл. Здесь:
          # handlers - обработчик используемого шаблона, на основе которого формируется конечный файл.
          # Обработчки наз. ":axlsx". template: 'admin/users/user' - представление, которое мы хотим
          # отрендерить и на основе которого сделать строку (представление будет располагаться в 'admin/users/user').
          # locals: { user: user } - локальная переменная, передаваемая представлению, которая будет
          # называться "user", и браться переменная будет из текущего "user". На основе данной переменной
          # сделаем файл Excel.
          zos.print render_to_string(
            layout: false, handlers: [:axlsx], formats: [:xlsx], template: 'admin/users/user', locals: { user: user }
          )
        end
      end

      # "Перемотать файл" - прочитать заново и отправить пользователю (rewind) архив "users.zip"
      # "send_data" - метод RoR
      compressed_filestream.rewind
      send_data compressed_filestream.read, filename: 'users.zip'
    end

    # найти юзера, которого есть желание отредактировать
    def set_user!
      @user = User.find params[:id]
    end

    # то, что мы хотим разрешить изменять в админке
    def user_params
      params.require(:user).permit(
        :email, :name, :password, :password_confirmation, :role
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
