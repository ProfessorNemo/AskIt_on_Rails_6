# frozen_string_literal: true

module QuestionsAnswers
  extend ActiveSupport::Concern

  included do
    def load_question_answers(do_render: false)
      # Декарирование вопроса, в том числе если ответ сохранить не удалось
      @question = @question.decorate
      # В нек-х случаях ответ уже присутствует, в методе "create", где build
      # относительно answer вызывался, поэтому мемоизация ||=
      @answer ||= @question.answers.build
      # Сортировка ответов по убыванию (самый свежий - сверху). Определим переменную
      # @answers и в том числе, если ответ сохранить не удалось, ибо render выдает только разметку на экран
      @pagy, @answers = pagy @question.answers.includes(:user).order(created_at: :desc)
      # Answer.where(question: @question).limit(2).order(created_at: :desc)
      @answers = @answers.decorate
      # "do_render" по умолчанию "false", но если передан "true" - то render()
      # по умолчанию RoR искала бы в директории "Answers"
      render('questions/show') if do_render
    end
  end
end

# created_at - поле в БД
# @answers =.........params[:page].per(2) - сколько показывать ответов на странице (по 3 ответа)
# @answers = @question.answers.order(created_at: :desc).page(params[:page]).per(3)

# или альтернатива с лимитированием (вывести 2 первых ответа)
# @answers = Answer.where(question: @question).limit(2).order created_at: :desc
# методы можно один за другим использоваться (по цепочке)
