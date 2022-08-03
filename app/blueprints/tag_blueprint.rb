# frozen_string_literal: true

# сериализатор
class TagBlueprint < Blueprinter::Base
  # для каждого тега берем его id
  identifier :id
  # название поля :title
  fields :title
end
