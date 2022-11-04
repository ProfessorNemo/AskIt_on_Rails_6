# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:body) do |n|
      "Yes, you go fuck yourself #{n}"
    end
    sequence(:question_id) { |n| n }
    sequence(:user_id) { |n| n }

    association :question, factory: :question
    association :user, factory: :user
  end
end

# Ответы принадлежат вопросам
# association :question, factory: :question
# Ассоциациация - question. И для построения этой ассоциации нужно
# использовать factory: :question
