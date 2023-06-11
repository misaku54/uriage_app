require 'rails_helper'

RSpec.describe "ユーザー管理機能（一般）", type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }

  describe '未ログイン' do
    describe 'ページ遷移確認' do
      context 'ユーザー詳細画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit user_path(user_a)
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

    describe '詳細表示機能' do
      context 'ユーザーAでログインしている場合' do
        let(:login_user) { user_a }
        
        it 'ユーザーAの詳細画面が表示されていること' do
          expect(page).to have_current_path user_path(user_a)
          expect(page).to have_content 'ユーザーA'
          expect(page).to have_content 'a@example.com'
        end
      end

      context 'ユーザーBでログインしている場合' do
        let(:login_user) { user_b }
      
        it 'ユーザーAの詳細画面に遷移するとホーム画面へ遷移すること' do
          visit user_path(user_a)
          expect(page).to have_current_path root_path
        end
      end
    end
  end
end
