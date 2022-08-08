# frozen_string_literal: true

class AnswerPolicy < ApplicationPolicy
  def create?
    !user.guest? && !user.blocked_status?
  end

  def update?
    user.admin_role? || user.moderator_role? || user.author?(record) if user.activated_status?
  end

  def index?
    true
  end

  def show?
    true
  end

  def destroy?
    user.admin_role? || user.author?(record) unless user.blocked_status?
  end
end
