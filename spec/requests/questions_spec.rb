# frozen_string_literal: true

require 'rails_helper'

RSpec.configure { |c| c.before { expect(controller).not_to be_nil } }

RSpec.describe QuestionsController, type: :controller do
  describe 'GET index' do
    it 'has a 200 status code' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
      expect(response.body).to eq ''
    end
  end

  describe 'responds to' do
    it 'responds to html by default' do
      post :create, params: { title: 'What are fucking shit?', body: 'My first name' }
      expect(response.content_type).to eq 'text/html; charset=utf-8'
    end
  end

  describe 'routing' do
    it 'routes GET /ru/questions to QuestionsController#index' do
      expect(get: '/ru/questions').to route_to(controller: 'questions', action: 'index', locale: 'ru')
    end

    it { expect(get: '/ru/questions/25').to route_to(controller: 'questions', action: 'show', locale: 'ru', id: '25') }

    it { expect(get: '/ru/question/250').not_to be_routable }
  end
end
