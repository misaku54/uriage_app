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

    describe 'ログイン機能' do
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

    describe '自動ログイン機能' do
      context '自動ログインにチェックがつけてログインした場合' do
        it 'クッキーが保存されていること' do
          session_params = { email: user.email, password: user.password, remember_me: 1 }
          post login_path, params: { session: session_params }
          expect(cookies[:remember_token]).to_not be_blank
        end
      end
      
      context '自動ログインにチェックをつけずにログインした場合' do
        it 'クッキーが保存されていないこと' do
          session_params = { email: user.email, password: user.password, remember_me: 0 }
          post login_path, params: { session: session_params }
          expect(cookies[:remember_token]).to be_blank
        end
      end
    end
  end

  describe '#destroy' do
    let(:user) { FactoryBot.create(:user) }
    describe 'ログアウト機能' do
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

        it 'もう一度ログアウトしてもエラーにならないこと' do
          delete logout_path
          expect(response).to redirect_to root_url
        end
      end
    end
  end
end
