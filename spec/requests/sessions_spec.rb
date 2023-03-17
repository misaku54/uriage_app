require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe '#new' do
    it 'レスポンスが正常であること' do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe '#create' do
    let(:user) { FactoryBot.create(:user) }

    context 'ログイン時、パスワードが誤っていた場合' do
      it 'ログイン画面を再表示すること' do
        session_params = { email: user.email, password: 'invalid'}
        post login_path, params: { session: session_params }
        expect(response.body).to include('ログイン')
      end
    end

    context 'ログインが成功した場合' do
      before do
        session_params = { email: user.email, password: user.password }
        post login_path, params: { session: session_params }
      end

      it 'ユーザー情報にリダイレクトされること' do
        expect(response).to redirect_to user
      end

      it 'ログイン状態になること' do
        expect(logged_in?).to be_truthy
      end
    end
  end

  describe '#destroy' do
    let(:user) { FactoryBot.create(:user) }

    context 'ログアウトが成功した場合' do
      before do
        session_params = { email: user.email, password: user.password }
        post login_path, params: { session: session_params }
        delete logout_path
      end

      it 'ホーム画面へリダイレクトされること' do
        expect(response).to redirect_to root_url
      end

      it 'ログアウト状態になること' do
        expect(logged_in?).to be_falsy
      end
    end
  end
end
