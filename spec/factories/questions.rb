# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:title) do |n|
      "Test questions #{n}"
    end
    sequence(:body) do |n|
      "Are you going to fuck? #{n}"
    end
    sequence(:user_id) { |n| n }

    trait :id do
      user_id { 1 }
    end

    factory :id, traits: [:id]

    association :user, factory: :user
  end
end
