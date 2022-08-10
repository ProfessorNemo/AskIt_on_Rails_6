# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Alex' }
    sequence :email do |n|
      "alex-fucking#{n}@gmail.com"
    end
    password_digest { 'Omega123456!' }
    role { 'basic' }
    status { 'activated' }

    factory :user_with_incorrect_email do
      email { 'test' }
    end

    trait :admin do
      role { 'admin' }
    end

    trait :blocked do
      status { 'blocked' }
    end

    factory :admin, traits: [:admin]
    factory :blocked, traits: [:blocked]
  end
end
