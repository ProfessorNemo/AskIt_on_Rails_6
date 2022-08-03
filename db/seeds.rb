# frozen_string_literal: true

# сгенерировать 30 вопросов
# 30.times do
#   # заголовок вопроса (предложение из 3-х слов)
#   title = Faker::Hipster.sentence(word_count: 3)
#   # тело вопроса (сгенерировать 5 предложений и добавлено до 4 рандомных предложений)
#   body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
#   # Сгенерировать новый вопрос с заголовком и телом
#   Question.create title: title, body: body
# end

# Нашли всех юзеров и после того как хэш пересчитали, юзеров сохранили
# "u.send(:set_gravatar_hash)" - вызов закрытого (под "private") метода
# User.find_each do |u|
#   u.send(:set_gravatar_hash)
#   u.save
# end

# создадим 30 тегов по случайным хипстерским словечкам
30.times do
  title = Faker::Hipster.word
  Tag.create title: title
end