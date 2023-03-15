require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET #new' do
    it 'レスポンスが正常であること' do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  
  describe 'POST #create' do
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
        user_params = FactoryBot.attributes_for(:user)
        expect {
          post users_path, params: { user: user_params }
        }.to change(User, :count).by(1)
      end
    end
  end
end
