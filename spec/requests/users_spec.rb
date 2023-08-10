require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#show' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:jhon) }
    
    context '未ログイン' do
      before do
        get user_path(user)
      end

      it 'ログイン画面にリダイレクトされること' do
        expect(response).to redirect_to login_path
      end
      
      it 'flashが表示されていること' do
        expect(flash).to be_any 
      end
    end

    context 'ログイン中' do
      before do
        log_in(user)
      end
      context '自身の詳細画面へのリクエストの場合' do  
        it 'レスポンスが正常であること' do
          get user_path(user)
          expect(response).to have_http_status(:success)
        end
      end

      context '別ユーザーの詳細画面へのリクエストの場合' do
        it 'ホーム画面にリダイレクトされること' do
          get user_path(other_user)
          expect(response).to redirect_to root_url
        end
      end
    end
  end
end
