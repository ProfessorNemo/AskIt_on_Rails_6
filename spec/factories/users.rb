# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'John' }
    sequence :email do |n|
      "fuckingJohn#{n}@example.com"
    end
    password_digest { '123' }
    role { 'basic' }

    factory :user_with_incorrect_email do
      email { 'test' }
    end

    trait :admin do
      role { 'admin' }
    end

    factory :admin, traits: [:admin]
  end
end
