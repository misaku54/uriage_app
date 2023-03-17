require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#new' do
    it 'レスポンスが正常であること' do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  
  describe '#create' do
    context '無効な値の場合' do
      it '登録されないこと' do
        user_params = FactoryBot.attributes_for(:invalid_user)
        expect {
          post users_path, params: { user: user_params }
        }.to_not change(User, :count)
      end
    end

    context '有効な値の場合' do
      it '登録されること' do
        expect {
          user_params = FactoryBot.attributes_for(:user)
          post users_path, params: { user: user_params }
        }.to change(User, :count).by(1)
      end

      it 'ログイン状態になること' do
        user_params = FactoryBot.attributes_for(:user)
        post users_path, params: { user: user_params }
        expect(logged_in?).to be_truthy
      end
    end
  end
end
