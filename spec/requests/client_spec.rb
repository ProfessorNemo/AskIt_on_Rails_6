# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exchange::Client do
  describe '#create_question' do
    let(:test_client) { described_class.new([]) }

    it 'creates question with proper params' do
      body = JSON.dump({ name: 'RSpec', request_method:	'POST' })

      stub_request(:post, 'http://127.0.0.1:3000/questions/')
        .with(
          body: body,
          headers: {
            accept: 'application/json',
            'token' => test_client.token
          }
        )
        .to_return(status: 200, body: body, headers: { content_type: 'application/json' })
      question = test_client.create_question name: 'RSpec', request_method: 'POST'
      expect(question[:request_method]).to eq('POST')
    end
  end

  it 'raises an error with invalid params' do
    stub_request(:post, 'http://127.0.0.1:3000/questions/')
      .to_raise(StandardError)

    expect { test_client.create_question({}) }.to raise_error(StandardError)
  end

  describe '#question' do
    let(:test_client) { described_class.new(ENV.fetch('TOKEN', 'fake')) }
    let(:question_id) { 68 }

    it 'open question with current id' do
      # JSON.dump - чтобы получить строку на основе хэша
      body = JSON.dump(
        'question_id' => question_id,
        'machine_name' =>	'127.0.0.1',
        'request_method' =>	'GET',
        'user' =>	'127.0.0.1',
        'name' =>	'/packs/css/application.css.map'
      )

      stub_request(:get, "http://127.0.0.1:3000/questions/#{question_id}")
        .with(
          headers: {
            'token' => test_client.token
          }
        )
        .to_return(status: 200, body: body, headers: { content_type: 'application/json' })

      question = test_client.question question_id
      expect(question['question_id']).to eq(question_id)
      expect(WebMock).to have_requested(
        :get, "http://127.0.0.1:3000/questions/#{question_id}"
      ).once
    end
  end
end
