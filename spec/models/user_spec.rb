# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'a user' do
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:role) }
  it { is_expected.to respond_to(:email) }
end

RSpec.describe User, type: :model do
  it_behaves_like 'a user'
  context 'validates' do
    it 'is valid' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'email is true and users save to base' do
      user = build(:user)
      expect(user.email).to be_truthy
      # сохраняется объект без ошибок
      expect { user.save }.not_to raise_error
    end

    it 'name is required' do
      user = build(:user, name: nil)
      expect(user).to be_valid
    end

    it 'email is required' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'password_digest is required' do
      user = build(:user, password_digest: nil)
      expect(user).not_to be_valid
    end

    specify 'password_digest' do
      user = build(:user, password_digest: '123')
      expect(user.password_digest).to eq('123')
    end

    it 'User name is John and basic' do
      user = build(:user)
      expect(user.name).to eq('John')
      expect(user.role).to eq('basic')
    end

    it 'email is correct' do
      user = build(:user_with_incorrect_email)
      expect(user).not_to be_valid
    end

    it 'user is empty' do
      user = attributes_for(:user)
      expect(user).not_to be_empty
      puts user.inspect
    end
  end

  context 'validates_2' do
    it 'validates_user_admin' do
      user = build_stubbed(:admin)
      expect(user.role).to eq('admin')
      expect(user.id).to be_truthy
      puts user.inspect
    end
  end
end
