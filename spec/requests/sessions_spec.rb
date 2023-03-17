require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe '#new' do
    it 'レスポンスが正常であること' do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end
  
  describe '#create' do
    context 'メールアドレスは正しいが、パスワードが誤っていた場合' do
      before do
        user = FactoryBot.create(:user)
        session_params = { email: user.email, password: 'invalid'}
        post login_path, params: { session: session_params }
      end

      it 'ログイン画面を再表示すること' do
        expect(response.body).to include('ログイン')
      end
    end
  end
end
