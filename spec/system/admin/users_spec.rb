require 'rails_helper'

RSpec.describe "ユーザー管理機能（管理者）", type: :system do
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let!(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
  let!(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
  
  describe '未ログイン' do
    describe 'ページ遷移確認' do
      context 'ユーザー一覧画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit admin_users_path
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context 'ユーザー詳細画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit admin_user_path(admin_user)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context 'ユーザー登録画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit new_admin_user_path
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context 'ユーザー編集画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit edit_admin_user_path(:user_a)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end 
      end
    end
  end

  describe 'ログイン中' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログイン'
    end

    describe '一覧表示機能' do
      context '管理者でログインしている場合' do
        let(:login_user) { admin_user }

        it 'ユーザーA、ユーザーBの情報が表示されていること' do
          visit admin_users_path
          expect(page).to have_content 'ユーザーA'
          expect(page).to have_content 'a@example.com'
          expect(page).to have_content 'ユーザーB'
          expect(page).to have_content 'b@example.com'
        end
      end

      context '一般ユーザーでログインしている場合' do
        let(:login_user) { user_a }

        it 'ホーム画面へリダイレクト遷移すること' do
          visit admin_users_path
          expect(page).to have_current_path root_path
        end
      end
    end

    describe '編集機能' do
      
    end
  end
end