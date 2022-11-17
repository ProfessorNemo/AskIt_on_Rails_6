# frozen_string_literal: true

RSpec.describe Answer do
  let!(:user) { create(:admin) }
  let!(:question) { create(:id) }
  let!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

  describe 'slugs' do
    specify '#user_id' do
      puts question.inspect
      puts answer.inspect
      puts user.inspect
      expect(user.role).to eq('admin')
      expect(question.user_id == answer.user_id).not_to be_truthy
    end
  end
end
