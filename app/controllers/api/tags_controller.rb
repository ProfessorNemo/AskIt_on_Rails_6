# frozen_string_literal: true

module Api
  class TagsController < ApplicationController
    def index
      tags = Tag.arel_table
      # запрос - я хочу найти все теги, заголовки которых
      # содержат слово "%#{params[:term]}%"
      @tags = Tag.where(tags[:title].matches("%#{params[:term]}%"))

      # render(@tags) выполнит сериализацию и превратит коллекцию тегов в json
      render json: TagBlueprint.render(@tags)
    end
  end
end
