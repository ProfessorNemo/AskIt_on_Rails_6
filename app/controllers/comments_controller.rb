# frozen_string_literal: true

class CommentsController < ApplicationController
  include QuestionsAnswers
  before_action :set_commentable!
  before_action :set_question

  def create
    # создать новый комментарий для commentable
    @comment = @commentable.comments.build comment_params
    # @comment.user = current_user

    if @comment.save
      flash[:success] = t '.success'
      redirect_to question_path(@question)
    # редирект на элемент, для которого писался комментарий, но нет метода show
    # для контроллера "answers и нужного маршрута
    # redirect_to @commentable
    else
      @comment = @comment.decorate
      load_question_answers do_render: true
    end
  end

  def destroy
    comment = @commentable.comments.find params[:id]
    comment.destroy
    flash[:success] = t '.success'
    redirect_to question_path(@question)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  # В параметрах будем находить либо аттрибут question_id, либо answer_id
  # "!" - опасный м-д, в нем может возникнуть исключение "raise"
  def set_commentable!
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"] }
    # Если не удалось понять, для какого класса создался комментарий - т.е. прислали левый запрос
    raise ActiveRecord::RecordNotFound if klass.blank?

    # klass = Question или klass = Answer. Затем находим конкретный вопрос или ответ,
    # для которого нужно написать комментарий. (underscore - к нижнему регистру)
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  # Если @commentable - это Question, то - @commentable, если не Question - то Answer,
  # т.е. @commentable.question. И вытаскиваем ответ
  def set_question
    @question = @commentable.is_a?(Question) ? @commentable : @commentable.question
  end
end
