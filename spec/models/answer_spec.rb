# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:admin) }
  let(:question) { create(:id) }
  let(:answer) { create(:answer, question_id: 1, user_id: 1) }

  describe 'slugs' do
    specify '#user_id' do
      puts question.inspect
      puts answer.inspect
      puts user.inspect
      expect(user.role).to eq('admin')
      expect(question.user_id == answer.user_id).to be_truthy
    end
  end
end
