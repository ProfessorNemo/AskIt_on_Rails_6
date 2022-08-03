module Api
  class TagsController < ApplicationController
    def index
      tags = Tag.arel_table
      # запрос - я хочу найти все теги, заголовки которых
      # содержат слово "%#{params[:term]}%"
      @tags = Tag.where(tags[:title].matches("%#{params[:term]}%"))

      respond_to do |format|
        format.json
      end
    end
  end
end
