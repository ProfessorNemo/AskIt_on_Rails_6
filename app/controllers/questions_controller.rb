# frozen_string_literal: true

class QuestionsController < ApplicationController
  include QuestionsAnswers
  before_action :set_question!, only: %i[show destroy edit update]

  def show
    load_question_answers
  end

  def index
    @tags = Tag.where(id: params[:tag_ids]) if params[:tag_ids]
    @pagy, @questions = pagy Question.all_by_tags(@tags)
    @questions = @questions.decorate
  end

  def new
    @question = Question.new
  end

  def edit; end

  def update
    if @question.update question_params
      flash[:success] = t('.success')
      redirect_to questions_path
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    flash[:success] = t('.success')
    redirect_to questions_path
  end

  def create
    # отрендерить обычный текст с параметрами запроса
    # render plain: params
    # для текущего юзера построить вопрос с таким-то параметрами
    @question = current_user.questions.build question_params
    if @question.save
      flash[:success] = t('.success')
      redirect_to questions_path
    else
      render :new
    end
  end

  private

  # из присланных параметров найти вопрос и достать только title и body
  # "tag_ids: []" - т.е. на данной позиции может идти целый массив из "id",
  # и каждый id представляет собой один тег
  def question_params
    params.require(:question).permit(:title, :body, tag_ids: [])
  end

  def set_question!
    @question = Question.find params[:id]
  end
end
