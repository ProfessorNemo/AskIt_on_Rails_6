# frozen_string_literal: true

class CommentDecorator < ApplicationDecorator
  delegate_all
  # задекорировать юзера для комментария
  decorates_association :user
end
