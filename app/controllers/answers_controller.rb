# frozen_string_literal: true

class AnswersController < ApplicationController
  include QuestionsAnswers
  # модуль для якорей
  include ActionView::RecordIdentifier
  # и для create и для destroy
  # порядок action важен: сначала идет вопрос, потом ответ
  before_action :set_question!
  before_action :set_answer!, except: :create
  before_action :authorize_answer!
  after_action :verify_authorized

  def update
    if @answer.update answer_update_params
      flash[:success] = t('.success')
      redirect_to question_path(@question, anchor: dom_id(@answer))
    else
      render :edit
    end
  end

  def edit; end

  def create
    # Есть уже привязка к @question. Тогда привязка к @user см. в методе
    # "answer_params" - .merge(user_id: current_user.id)
    @answer = @question.answers.build answer_create_params

    if @answer.save
      flash[:success] = t('.success')
      redirect_to question_path(@question)
    else
      load_question_answers(do_render: true)
    end
  end

  def destroy
    @answer.destroy
    flash[:success] = t('.success')
    redirect_to question_path(@question)
  end

  private

  # в параметры для создания ответа юзером добавлен параметр "user_id"
  def answer_create_params
    params.require(:answer).permit(:body).merge(user_id: current_user.id)
  end

  # при редактировании чужих ответов чтобы не было привязки к одному и тому же юзеру
  def answer_update_params
    params.require(:answer).permit(:body)
  end

  def set_question!
    @question = Question.find params[:question_id]
  end

  def set_answer!
    @answer = @question.answers.find params[:id]
  end

  def authorize_answer!
    authorize(@answer || Answer)
  end
end
