# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Box::Github do
  let(:user_response) do
    VCR.use_cassette('users/user') { described_class.user('ruby') }
  end

  it 'can fetch & parse user data' do
    expect(user_response).to be_kind_of(Hash)

    expect(user_response).to have_key(:id)
    expect(user_response).to have_key(:type)
  end
end
