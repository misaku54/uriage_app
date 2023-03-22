require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  describe '#show' do
    let(:user) { FactoryBot.create(:user) }
    let(:admin_user) { FactoryBot.create(:admin_user) } 
    
    context '未ログインの場合' do
      it 'ホーム画面にリダイレクトされること' do
        get admin_user_path(user)
        expect(response).to redirect_to root_path
      end
    end

    context '一般ユーザーでログインしている場合' do
      it 'ホーム画面にリダイレクトされること' do
        log_in(user)
        get admin_user_path(user)
        expect(response).to redirect_to root_path
      end
    end

    context '管理ユーザーでログインしている場合' do
      it 'レスポンスが正常であること' do
        log_in(admin_user)
        get admin_user_path(admin_user)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#new' do
    let(:user) { FactoryBot.create(:user) }
    let(:admin_user) { FactoryBot.create(:admin_user) } 

    context '未ログインの場合' do
      it 'ホーム画面にリダイレクトされること' do
        get new_admin_user_path
        expect(response).to redirect_to root_path
      end
    end

    context '一般ユーザーでログインしている場合' do
      it 'ホーム画面にリダイレクトされること' do
        log_in(user)
        get new_admin_user_path
        expect(response).to redirect_to root_path
      end
    end

    context '管理ユーザーでログインしている場合' do
      it 'レスポンスが正常であること' do
        log_in(admin_user)
        get new_admin_user_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#create' do
    let(:user) { FactoryBot.create(:user) }
    let(:admin_user) { FactoryBot.create(:admin_user) } 

    context '未ログインの場合' do
      context '無効な値の場合' do
        it '登録されないこと' do
          user_params = FactoryBot.attributes_for(:invalid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to_not change(User, :count)
        end

        it 'ホーム画面にリダイレクトされること' do
          user_params = FactoryBot.attributes_for(:invalid_user)
          post admin_users_path, params: { user: user_params }
          expect(response).to redirect_to root_path
        end
      end

      context '有効な値の場合' do
        it '登録されないこと' do
          user_params = FactoryBot.attributes_for(:valid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to_not change(User, :count)
        end

        it 'ホーム画面にリダイレクトされること' do
          user_params = FactoryBot.attributes_for(:valid_user)
          post admin_users_path, params: { user: user_params}
          expect(response).to redirect_to root_path
        end
      end
    end

    context '一般ユーザーでログインしている場合' do
      before do
        log_in(user)
      end

      context '無効な値の場合' do
        it '登録されないこと' do
          user_params = FactoryBot.attributes_for(:invalid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to_not change(User, :count)
        end

        it 'ホーム画面にリダイレクトされること' do
          user_params = FactoryBot.attributes_for(:invalid_user)
          post admin_users_path, params: { user: user_params }
          expect(response).to redirect_to root_path
        end
      end
      
      context '有効な値の場合' do
        it '登録されないこと' do
          user_params = FactoryBot.attributes_for(:valid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to_not change(User, :count)
        end

        it 'ホーム画面にリダイレクトされること' do
          user_params = FactoryBot.attributes_for(:valid_user)
          post admin_users_path, params: { user: user_params}
          expect(response).to redirect_to root_path
        end
      end
    end

    context '管理ユーザーでログインしている場合' do
      before do
        log_in(admin_user)
      end

      context '無効な値の場合' do
        it '登録されないこと' do
          user_params = FactoryBot.attributes_for(:invalid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to_not change(User, :count)
        end

        it '新規登録画面へ遷移すること' do
          user_params = FactoryBot.attributes_for(:invalid_user)
          post admin_users_path, params: { user: user_params}
          expect(response.body).to include('新規登録')
        end
      end
      
      context '有効な値の場合' do
        it '登録されること' do
          user_params = FactoryBot.attributes_for(:valid_user)
          expect {
            post admin_users_path, params: { user: user_params }
          }.to change(User, :count).by(1)
        end

        it 'ユーザー情報画面にリダイレクトされること' do
          user_params = FactoryBot.attributes_for(:valid_user)
          post admin_users_path, params: { user: user_params }
          create_user = User.last
          expect(response).to redirect_to admin_user_path(create_user)
        end

        it 'flashが表示されていること' do
          user_params = FactoryBot.attributes_for(:valid_user)
          post admin_users_path, params: { user: user_params }
          expect(flash).to be_any
        end
      end
    end
  end

  describe '#edit' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:jhon) }
    let(:admin_user) { FactoryBot.create(:admin_user) } 

    context '未ログインの場合' do
      before do
        get edit_admin_user_path(user)
      end

      it 'ホーム画面にリダイレクトされること' do
        expect(response).to redirect_to root_path
      end
    end

    context '一般ユーザーでログインしている場合' do
      before do
        log_in(user)
      end

      it 'ホーム画面にリダイレクトされること' do
        get edit_admin_user_path(user)
        expect(response).to redirect_to root_path
      end

      context '別のユーザーの編集画面に遷移した場合' do
        it 'ホーム画面にリダイレクトされること' do
          get edit_admin_user_path(other_user)
          expect(response).to redirect_to root_path
        end
      end
    end

    context '管理ユーザーでログインしている場合' do
      it 'レスポンスが正常であること' do
        log_in(admin_user)
        get edit_admin_user_path(user)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#update' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:jhon) }
    let(:admin_user) { FactoryBot.create(:admin_user) } 

    context '未ログインの場合' do
      context '無効な値で更新した場合' do
        before do
          @user_params = FactoryBot.attributes_for(:invalid_user)
          patch admin_user_path(user), params: { user: @user_params }
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

        it 'ホーム画面へリダイレクトされること' do
          expect(response).to redirect_to root_path
        end
      end

      context '有効な値で更新した場合' do
        before do
          @name  = 'Foo Bar'
          @email = 'foo@bar.com'
          patch admin_user_path(user), params: { user: {  name:  @name,
                                                    email: @email,
                                                    password:              '',
                                                    password_confirmation: '' } }
        end

        it '更新されないこと' do
          user.reload
          aggregate_failures do
            expect(user.name).to_not eq @name
            expect(user.email).to_not eq @email
          end
        end
        
        it 'ホーム画面へリダイレクトされること' do
          expect(response).to redirect_to root_path
        end
      end

      context '別のユーザーを更新した場合' do
        before do
          patch admin_user_path(other_user), params: { user: {  name:  'Foo Bar',
                                                          email: 'foo@bar.com',
                                                          password:              "",
                                                          password_confirmation: "" } }
        end

        it '更新されないこと' do
          other_user.reload
          aggregate_failures do
            expect(other_user.name).to eq 'Test Jhon'
            expect(other_user.email).to eq 'jhon@example.com'
            expect(other_user.password).to eq 'password'
            expect(other_user.password_confirmation).to eq 'password'
          end
        end

        it 'ホーム画面へリダイレクトされること' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'ログインしている場合' do
      before do
        log_in(user)
      end
    
      context '無効な値で更新した場合' do
        before do
          @user_params = FactoryBot.attributes_for(:invalid_user)
          patch admin_user_path(user), params: { user: @user_params }
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

        it 'ホーム画面へリダイレクトされること' do
          expect(response).to redirect_to root_path
        end
      end

      context '有効な値で更新した場合' do
        before do
          @name  = 'Foo Bar'
          @email = 'foo@bar.com'
          patch admin_user_path(user), params: { user: {  name:  @name,
                                                    email: @email,
                                                    password:              '',
                                                    password_confirmation: '' } }
        end

        it '更新されないこと' do
          user.reload
          aggregate_failures do
            expect(user.name).to_not eq @name
            expect(user.email).to_not eq @email
          end
        end
        
        it 'ホーム画面へリダイレクトされること' do
          expect(response).to redirect_to root_path
        end
      end

      context '別のユーザーを更新した場合' do
        before do
          patch admin_user_path(other_user), params: { user: {  name:  'Foo Bar',
                                                          email: 'foo@bar.com',
                                                          password:              "",
                                                          password_confirmation: "" } }
        end

        it '更新されないこと' do
          other_user.reload
          aggregate_failures do
            expect(other_user.name).to eq 'Test Jhon'
            expect(other_user.email).to eq 'jhon@example.com'
            expect(other_user.password).to eq 'password'
            expect(other_user.password_confirmation).to eq 'password'
          end
        end

        it 'ホーム画面へリダイレクトされること' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context '管理ユーザーでログインしている場合' do
      before do
        log_in(admin_user)
      end

      context '無効な値で更新した場合' do
        before do
          @user_params = FactoryBot.attributes_for(:invalid_user)
          patch admin_user_path(user), params: { user: @user_params }
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

        it '編集画面へ遷移すること' do
          expect(response.body).to include('ユーザー編集')
        end
      end

      context '有効な値で更新した場合' do
        before do
          @name  = 'Foo Bar'
          @email = 'foo@bar.com'
          patch admin_user_path(user), params: { user: {  name:  @name,
                                                    email: @email,
                                                    password:              '',
                                                    password_confirmation: '' } }
        end

        it '更新されること' do
          user.reload
          aggregate_failures do
            expect(user.name).to eq @name
            expect(user.email).to eq @email
            expect(user.password).to eq 'password'
            expect(user.password_confirmation).to eq 'password'
          end
        end
        
        it 'ユーザー編集画面へリダイレクトすること' do
          expect(response).to redirect_to admin_user_path(user)
        end
      end
    end
  end
end
