# frozen_string_literal: true

namespace :fake do
  desc 'initial feck data'

  task questions: :environment do
    puts 'generate 30 random questions'

    # сгенерировать 30 вопросов
    30.times do
      # заголовок вопроса (предложение из 3-х слов)
      title = Faker::Hipster.sentence(word_count: 3)
      # тело вопроса (сгенерировать 5 предложений и добавлено до 4 рандомных предложений)
      body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
      # Сгенерировать новый вопрос с заголовком и телом
      Question.create title: title, body: body
    end
  end

  task user: :environment do
    p = 'Oceanborn20121703red!'
    User.create email: 'nemo@gmail.com',
                name: 'Nemo',
                password: p,
                password_confirmation: p,
                role: 0,
                status: 0

    User.create email: 'stranger@yandex.ru',
                name: 'Stranger',
                password: p,
                password_confirmation: p,
                role: 0,
                status: 0
  end

  task questions_user: :environment do
    user = User.first

    # сгенерировать 5 вопросов первого пользователя "user"
    5.times do
      title = Faker::Hipster.sentence(word_count: 3)
      body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
      question = user.questions.build title: title, body: body
      question.save
    end
  end

  task gravatar_user: :environment do
    # Нашли всех юзеров и после того как хэш пересчитали, юзеров сохранили
    # "u.send(:set_gravatar_hash)" - вызов закрытого (под "private") метода
    User.find_each do |u|
      u.send(:set_gravatar_hash)
      u.save
    end
  end

  task random_tags: :environment do
    # создадим 30 тегов по случайным хипстерским словечкам
    30.times do
      title = Faker::Hipster.word
      Tag.create title: title
    end
  end
end
