require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  describe '#new' do
    it 'レスポンスが正常であること' do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe '#create' do
    describe 'ログイン機能' do
      context 'ログインに失敗した場合（パスワード誤）' do
        it 'ログイン画面を再表示すること' do
          session_params = { email: user.email, password: 'invalid'}
          post login_path, params: { session: session_params }
          expect(response.body).to include('ログイン')
        end
      end

      context 'ログインが成功した場合' do
        it 'ログイン状態になり、ユーザー情報にリダイレクトされること' do
          session_params = { email: user.email, password: user.password }
          post login_path, params: { session: session_params }
          expect(response).to redirect_to root_path
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
    describe 'ログアウト機能' do
      context 'ログアウト時' do
        before do
          session_params = { email: user.email, password: user.password }
          post login_path, params: { session: session_params }
          delete logout_path
        end

        it 'ログアウト状態になり、ホーム画面へリダイレクトされること' do
          expect(response).to redirect_to root_url
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
