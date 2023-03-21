require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#show' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:jhon) }
    
    context '未ログインの場合' do
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

    context 'ログインしている場合' do
      before do
        log_in(user)
      end

      it 'レスポンスが正常であること' do
        get user_path(user)
        expect(response).to have_http_status(:success)
      end

      context '別のユーザーの編集画面に遷移した場合' do
        before do
          get user_path(other_user)
        end

        it 'ホーム画面にリダイレクトされること' do
          expect(response).to redirect_to root_url
        end

        it 'flashが空であること' do
          expect(flash).to be_empty 
        end
      end
    end
  end
end
