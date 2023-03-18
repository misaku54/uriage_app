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

  describe '#edit' do
    let(:user) { FactoryBot.create(:user) }
    it 'レスポンスが正常であること' do
      log_in(user)
      get user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe '#update' do
    let(:user) { FactoryBot.create(:user) }
      
    context 'ログインしている場合' do
      before do
        log_in(user)
      end
    
      context '無効な値で更新した場合' do
        before do
          @user_params = FactoryBot.attributes_for(:invalid_user)
          patch user_path(user), params: { user: @user_params }
        end
        it '更新されないこと' do
          user.reload
          aggregate_failures do
            expect(user.name).to_not eq @user_params[:name]
            expect(user.email).to_not eq @user_params[:email]
            expect(user.password).to_not eq @user_params[:password]
            expect(user.password_confirmation).to_not eq @user_params[:password_confirmation]
          end
        end
        it '編集画面に遷移すること' do
          expect(response.body).to include('ユーザー編集')
        end
      end

      context '有効な値で更新した場合' do
        before do
          @name  = "Foo Bar"
          @email = "foo@bar.com"
          # allow_nilを設定しているため、passwordがnil値の場合バリデーションに引っかからない。
          patch user_path(user), params: { user: { name:  @name,
                                                      email: @email,
                                                      password:              "",
                                                      password_confirmation: "" } }
        end

        it '更新されること' do
          user.reload
          aggregate_failures do
            expect(user.name).to eq @name
            expect(user.email).to eq @email
          end
        end

        it 'ユーザー情報画面へリダイレクトすること' do
          expect(response).to redirect_to user
        end

        it 'flashが表示されていること' do
          expect(flash).to be_any
        end
      end
    end
  end
end
