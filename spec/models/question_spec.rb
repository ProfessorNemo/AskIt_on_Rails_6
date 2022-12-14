# frozen_string_literal: true

RSpec.describe Question do
  describe 'slugs' do
    it 'creates a proper slug for Russian' do
      question = create(:id)
      user = build_stubbed(:admin)
      expect(question.user_id == user.id).not_to be_truthy
      puts question.inspect
      puts user.inspect
    end
  end
end
