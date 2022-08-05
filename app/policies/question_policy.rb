# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  # Кто может создавать новые вопросы? Все, кроме гостя
  def create?
    !user.guest?
  end

  # Кто может обновлять вопросы?
  # Юзер с ролью администратора, модератора или автор вопроса. Вопрос
  # передается в методе "authorize"
  def update?
    user.admin_role? || user.moderator_role? || user.author?(record)
  end

  def destroy?
    user.admin_role? || user.author?(record)
  end

  # Кто может просматриват список всех вопросов?
  # Это могут делать все, поэтому "true". Разрешим всем гостям.
  def index?
    true
  end

  # Кто может открывать конкретный вопрос? Это могут делать все,
  # поэтому "true". Разрешим всем гостям.
  def show?
    true
  end
end
