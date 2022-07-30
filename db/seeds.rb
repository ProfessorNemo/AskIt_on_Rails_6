# frozen_string_literal: true

# сгенерировать 30 вопросов
30.times do
  # заголовок вопроса (предложение из 3-х слов)
  title = Faker::Hipster.sentence(word_count: 3)
  # тело вопроса (сгенерировать 5 предложений и добавлено до 4 рандомных предложений)
  body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
  # Сгенерировать новый вопрос с заголовком и телом
  Question.create title: title, body: body
end
