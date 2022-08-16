# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Box::TagsJson do
  let(:user_tags) do
    VCR.use_cassette('users/user_tags') { described_class.tags }
  end

  it 'can fetch & parse user data' do
    expect(user_tags.first).to be_kind_of(Hash)

    expect(user_tags).to be_kind_of(Array)

    expect(user_tags.first).to respond_to(:keys)

    expect(user_tags.first).to have_key(:id)

    expect(user_tags.first).to have_key(:title)

    puts user_tags.inspect
  end
end
