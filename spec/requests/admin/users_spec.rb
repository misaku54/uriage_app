require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  describe '#show' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:admin_user) { FactoryBot.create(:admin_user) } 
    
    context '未ログイン' do
      it 'ホーム画面にリダイレクトされること' do
        get admin_user_path(user)
        expect(response).to redirect_to root_path
      end
    end

    context '一般ユーザーでログイン中' do
      it 'ホーム画面にリダイレクトされること' do
        log_in(user)
        get admin_user_path(user)
        expect(response).to redirect_to root_path
      end
    end

    context '管理ユーザーでログイン中' do
      it 'レスポンスが正常であること' do
        log_in(admin_user)
        get admin_user_path(admin_user)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#new' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:admin_user) { FactoryBot.create(:admin_user) } 

    context '未ログイン' do
      it 'ホーム画面にリダイレクトされること' do
        get new_admin_user_path
        expect(response).to redirect_to root_path
      end
    end

    context '一般ユーザーでログイン中' do
      it 'ホーム画面にリダイレクトされること' do
        log_in(user)
        get new_admin_user_path
        expect(response).to redirect_to root_path
      end
    end

    context '管理ユーザーでログイン中' do
      it 'レスポンスが正常であること' do
        log_in(admin_user)
        get new_admin_user_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#create' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:admin_user) { FactoryBot.create(:admin_user) } 

    context '未ログイン' do
      context '無効なパラメーターの場合' do
        it '登録されずに、ホーム画面へリダイレクトされること' do
          user_params = FactoryBot.attributes_for(:invalid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to_not change(User, :count)
          expect(response).to redirect_to root_path
        end
      end

      context '有効なパラメーターの場合' do
        it '登録されずに、ホーム画面へリダイレクトされること' do
          user_params = FactoryBot.attributes_for(:valid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to_not change(User, :count)
          expect(response).to redirect_to root_path
        end
      end
    end

    context '一般ユーザーでログイン中' do
      before do
        log_in(user)
      end

      context '無効なパラメーターの場合' do
        it '登録されずに、ホーム画面へリダイレクトされること' do
          user_params = FactoryBot.attributes_for(:invalid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to_not change(User, :count)
          expect(response).to redirect_to root_path
        end
      end
      
      context '有効なパラメーターの場合' do
        it '登録されずに、ホーム画面へリダイレクトされること' do
          user_params = FactoryBot.attributes_for(:valid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to_not change(User, :count)
          expect(response).to redirect_to root_path
        end
      end
    end

    context '管理ユーザーでログイン中' do
      before do
        log_in(admin_user)
      end

      context '無効なパラメーターの場合' do
        it '登録されずに、新規登録画面へ遷移すること' do
          user_params = FactoryBot.attributes_for(:invalid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to_not change(User, :count)
          expect(response.body).to include('新規登録')
        end
      end
      
      context '有効なパラメーターの場合' do
        it '登録されて、ユーザー情報画面にリダイレクトされ、flashが表示されていること' do
          user_params = FactoryBot.attributes_for(:valid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to change(User, :count).by(1)

          create_user = User.last
          expect(response).to redirect_to admin_user_path(create_user)
          expect(flash).to be_any
        end
      end
    end
  end

  describe '#edit' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:jhon) }
    let!(:admin_user) { FactoryBot.create(:admin_user) } 

    context '未ログイン' do
      it 'ホーム画面にリダイレクトされること' do
        get edit_admin_user_path(user)
        expect(response).to redirect_to root_path
      end
    end

    context '一般ユーザーでログイン中' do
      it 'ホーム画面にリダイレクトされること' do
        log_in(user)
        get edit_admin_user_path(user)
        expect(response).to redirect_to root_path
      end
    end

    context '一般ユーザーでログイン中' do
      context '別ユーザーの編集画面へのリクエストの場合' do
        it 'ホーム画面にリダイレクトされること' do
          log_in(user)
          get edit_admin_user_path(other_user)
          expect(response).to redirect_to root_path
        end
      end
    end

    context '管理ユーザーでログイン中' do
      it 'レスポンスが正常であること' do
        log_in(admin_user)
        get edit_admin_user_path(user)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#update' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:jhon) }
    let!(:admin_user) { FactoryBot.create(:admin_user) } 

    context '未ログイン' do
      context '無効なパラメータの場合' do
        it '更新されずに、ホーム画面へリダイレクトされること' do
          @user_params = FactoryBot.attributes_for(:invalid_user)
          patch admin_user_path(user), params: { user: @user_params }

          user.reload
          expect(user.name).to_not eq @user_params[:name]
          expect(user.email).to_not eq @user_params[:email]
          expect(user.password).to_not eq @user_params[:password]
          expect(user.password_confirmation).to_not eq @user_params[:password_confirmation]
          expect(response).to redirect_to root_path
        end
      end

      context '有効なパラメータの場合' do
        it '更新されずに、ホーム画面へリダイレクトされること' do
          name  = 'Foo Bar'
          email = 'foo@bar.com'
          patch admin_user_path(user), params: { user: {  name:  name,
                                                          email: email,
                                                          password:              '',
                                                          password_confirmation: '' } }
          user.reload
          expect(user.name).to_not eq @name
          expect(user.email).to_not eq @email
          expect(response).to redirect_to root_path
        end
      end

      context '有効なパラメータで、別のユーザーを更新しようとした場合' do
        it '更新されずに、ホーム画面へリダイレクトされること' do
          patch admin_user_path(other_user), params: { user: {  name:  'Foo Bar',
                                                                email: 'foo@bar.com',
                                                                password:              "",
                                                                password_confirmation: "" } }
          other_user.reload
          expect(other_user.name).to eq 'Test Jhon'
          expect(other_user.email).to eq 'jhon@example.com'
          expect(other_user.password).to eq 'password'
          expect(other_user.password_confirmation).to eq 'password'
          expect(response).to redirect_to root_path
        end
      end
    end

    context '一般ユーザーでログイン中' do
      before do
        log_in(user)
      end
    
      context '無効なパラメータの場合' do
        it '更新されずに、ホーム画面へリダイレクトされること' do
          @user_params = FactoryBot.attributes_for(:invalid_user)
          patch admin_user_path(user), params: { user: @user_params }
          user.reload
          aggregate_failures do
            expect(user.name).to_not eq @user_params[:name]
            expect(user.email).to_not eq @user_params[:email]
            expect(user.password).to_not eq @user_params[:password]
            expect(user.password_confirmation).to_not eq @user_params[:password_confirmation]
            expect(response).to redirect_to root_path
          end
        end
      end

      context '有効なパラメータの場合' do
        it '更新されずに、ホーム画面へリダイレクトされること' do
          name  = 'Foo Bar'
          email = 'foo@bar.com'
          patch admin_user_path(user), params: { user: {  name:  name,
                                                          email: email,
                                                          password:              '',
                                                          password_confirmation: '' } }
          user.reload
          expect(user.name).to_not eq name
          expect(user.email).to_not eq email
          expect(response).to redirect_to root_path
        end
      end

      context '有効なパラメータで、別のユーザーを更新しようとした場合' do
        it '更新されずに、ホーム画面へリダイレクトされること' do
          patch admin_user_path(other_user), params: { user: {  name:  'Foo Bar',
                                                                email: 'foo@bar.com',
                                                                password:              "",
                                                                password_confirmation: "" } }
          other_user.reload
          expect(other_user.name).to eq 'Test Jhon'
          expect(other_user.email).to eq 'jhon@example.com'
          expect(other_user.password).to eq 'password'
          expect(other_user.password_confirmation).to eq 'password'
          expect(response).to redirect_to root_path
        end
      end
    end

    context '管理ユーザーでログイン中' do
      before do
        log_in(admin_user)
      end

      context '無効なパラメータの場合' do
        it '更新されずに、編集画面へ遷移すること' do
          @user_params = FactoryBot.attributes_for(:invalid_user)
          patch admin_user_path(user), params: { user: @user_params }
          user.reload
          expect(user.name).to_not eq @user_params[:name]
          expect(user.email).to_not eq @user_params[:email]
          expect(user.password).to_not eq @user_params[:password]
          expect(user.password_confirmation).to_not eq @user_params[:password_confirmation]
          expect(response.body).to include('ユーザー編集')
        end
      end

      context '有効なパラメータの場合' do
        it '更新され、ユーザー編集画面へリダイレクト後、flashが表示されていること' do
          name  = 'Foo Bar'
          email = 'foo@bar.com'
          patch admin_user_path(user), params: { user: {  name: name,
                                                          email: email,
                                                          password:              '',
                                                          password_confirmation: '' } }
          user.reload
          expect(user.name).to eq name
          expect(user.email).to eq email
          expect(user.password).to eq 'password'
          expect(user.password_confirmation).to eq 'password'
          expect(response).to redirect_to admin_user_path(user)
          expect(flash).to be_any
        end
      end
    end
  end

  describe '#destroy' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:jhon) }
    let!(:admin_user) { FactoryBot.create(:admin_user) } 

    context '未ログイン' do
      it '削除されずに、ホーム画面へリダイレクトされること' do
        expect {
          delete admin_user_path(other_user)
        }.to_not change(User, :count)
        expect(response).to redirect_to root_path
      end
    end

    context '一般ユーザーでログイン中' do
      it '削除されずに、ホーム画面へリダイレクトされること' do
        log_in(user)
        expect {
          delete admin_user_path(other_user)
        }.to_not change(User, :count)
        expect(response).to redirect_to root_path
      end
    end

    context '管理ユーザーでログイン中' do
      it '削除され、ユーザー管理画面へリダイレクトされること' do
        log_in(admin_user)
        expect {
          delete admin_user_path(other_user)
        }.to change(User, :count).by(-1)
        expect(response).to redirect_to admin_users_path
      end
    end
  end
end
