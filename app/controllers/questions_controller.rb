# frozen_string_literal: true

class QuestionsController < ApplicationController
  include QuestionsAnswers
  # Проверка, что юзер вошел в систему во всех случаях, кроме когда он
  # просматривает все вопросы или конкретный вопрос. Но если он пытается создать
  # вопрос или отредактировать, то мы требуем, чтобы он вошел в систему, иначе
  # мы не может проверить его права доступа.
  before_action :require_authentication, except: %i[show index]
  before_action :set_question!, only: %i[show destroy edit update]
  # Проверяем, имеет ли пользователь право на выполнение запрошенного действия
  before_action :authorize_question!
  # М-д "verify_authorized" доступен из Pundit и он проверит, что мы в нашем "before_action"
  # проверили права доступа. Если проверены не были, то выскочит ошибка. Проверка во всех
  # действиях контроллера
  after_action :verify_authorized

  def index
    @tags = Tag.where(id: params[:tag_ids]) if params[:tag_ids]
    @pagy, @questions = pagy Question.all_by_tags(@tags)
    @questions = @questions.decorate
  end

  def show
    load_question_answers
  end

  def new
    @question = Question.new
  end

  def edit; end

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

  # Нужно авторизовать конкретный вопрос или просто использовать модель. Т.е. если
  # вопрос есть, то мы делаем проверку относительно него. Если вопроса нет, то мы говорим
  # что юзер пытается делать что-то относительно ресурса вопроса.
  # Метод "authorize" доступен из Pundit, потому что в ApplicationController заинклюдили
  # concern "Authorization", а этот concern в свою очередь инклюдит Pundit
  def authorize_question!
    authorize(@question || Question)
  end
end
