# frozen_string_literal: true

# для отправки запросов

module Exchange
  module Rest
    include Exchange::Request

    # найти вопрос на стороннем сервисе по его идентификатору
    # "question_id". Здесь мы генерируем путь к вопросу и отправляем
    # self, который будет указывать на клиента
    def question(question_id)
      get "questions/#{question_id}", self, {}
    end

    # Создать новый вопрос с заданными параметрами
    def create_question(params)
      post params
    end
  end
end

# self будет указывать на Client, потому что в Client "include Helpers::Exchange::Rest".
# Берём self, передаём его в get. Затем в get (см. module Request) передаем "client",
# который в себе содержит токен и затем в подключении (см. module Connection) мы этого
# "client" принимаем и вытаскиваем его токен ('X-Api-Token' => client.token), таким образом
# пристыковывая его к заголовкам.
