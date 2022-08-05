# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization

    # "NotAuthorizedError" - назв. ошибки. С помощью метода
    # "user_not_authorized" будем делать rescue
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    # редирект либо туда, где был юзер до попытки выполнения действия. Если
    # "request.referer" нет, то на заглавную страницу
    def user_not_authorized
      flash[:danger] = t 'global.flash.not_authorized'
      redirect_to(request.referer || root_path)
    end
  end
end
