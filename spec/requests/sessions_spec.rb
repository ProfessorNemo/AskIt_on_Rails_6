# frozen_string_literal: true

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) do
      User.new email: Faker::Internet.email, name: Faker::Name.name
    end

    before do
      user.password = 'Mars123456!'
      user.password_confirmation = 'Mars123456!'
      user.save
      user.remember_me
      cookies.encrypted.permanent[:remember_token] = user.remember_token
      cookies.encrypted.permanent[:user_id] = user.id
    end

    it 'create :remember_token in cookies' do
      post :create, params: user[:params]
      expect(cookies[:remember_token]).not_to be_nil
      expect(user.remember_token_digest).to be_truthy
      expect(user.remember_token_digest).to be_an_instance_of(String)
      expect(response).to have_http_status(:found)

      puts ">> With response: #{response.location.inspect}"
      puts ">> With cookies.to_hash: #{cookies.to_hash.inspect}"
    end
  end

  describe '#new' do
    it 'render :new' do
      new_user = build(:user)
      get :new, params: {
        user: {
          id: new_user.id,
          username: 'asjdhajsdhasjdhaksjdh234723648723642783',
          email: new_user.email
        }
      }
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    it 'redirects to @user' do
      # u = User.select(:id).max.id
      new_user = User.new(id: 1, name: Faker::Name.name,
                          email: Faker::Internet.email)
      post :create, params: {
        user: {
          id: new_user.id,
          username: new_user.name,
          email: new_user.email
        }
      }
      expect(response.content_type).to eq 'text/html; charset=utf-8'
      expect(new_user.id).to eq(1)
    end
  end
end
