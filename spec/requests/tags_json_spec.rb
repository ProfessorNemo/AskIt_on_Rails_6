# frozen_string_literal: true

RSpec.describe Box::TagsJson do
  let(:user_tags) do
    VCR.use_cassette('users/user_tags') { described_class.tags }
  end

  it 'can fetch & parse user data' do
    expect(user_tags.first).to be_a(Hash)

    expect(user_tags).to be_a(Array)

    expect(user_tags.first).to respond_to(:keys)

    expect(user_tags.first).to have_key(:id)

    expect(user_tags.first).to have_key(:title)

    puts user_tags.inspect
  end
end
