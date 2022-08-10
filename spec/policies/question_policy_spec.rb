# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  subject { described_class.new(user, question) }

  let(:question) { Question.new title: 'Test questions', body: 'Are you going to fuck?', user_id: 1 }

  context 'being a visitor' do
    let(:user) { nil }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'being an author' do
    let(:user) do
      User.create name: 'Alex', email: 'alex-fucking@gmail.com',
                  role: 'basic', status: 'activated', password_digest: 'Omega123456!'
    end

    it { is_expected.to permit_actions(%i[show destroy]) }
  end

  context 'being an administrator' do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_actions(%i[show destroy]) }
  end

  context 'being an blocked' do
    let(:user) { build_stubbed(:blocked) }

    it { is_expected.to forbid_actions(%i[create update destroy edit]) }
  end
end
