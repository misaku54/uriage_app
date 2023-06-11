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

  # describe 'ログイン中' do
  #   before do
  #     visit login_path
  #     fill_in 'メールアドレス', with: login_user.email
  #     fill_in 'パスワード', with: login_user.password
  #     click_button 'ログイン'
  #   end

  #   describe '詳細表示機能' do
  #     context 'ユーザーAがログインしている場合' do
  #       let(:login_user) { user_a }
        
  #       it '' do

  #       end
  #     end
  #   end
  # end
  # describe '新規登録機能' do
  #   context '無効な値で新規登録した場合' do
  #     it 'エラーメッセージが表示されていること' do
  #       visit signup_path
  #       fill_in '名前', with: ''
  #       fill_in 'メールアドレス', with: 'user@invlid'
  #       fill_in 'パスワード', with: 'foo'
  #       fill_in 'パスワード確認', with: 'bar'
  #       click_button 'ユーザー登録'
  #       aggregate_failures do
  #         expect(page).to have_selector 'div#error_explanation'
  #         expect(page).to have_selector 'div.field_with_errors'
  #       end
  #     end
  #   end

  #   context '有効な値で新規登録した場合' do
  #     it '成功用のフラッシュメッセージが表示されていること' do
  #       visit signup_path
  #       fill_in '名前', with: 'Example User'
  #       fill_in 'メールアドレス', with: 'user@example.com'
  #       fill_in 'パスワード', with: 'password'
  #       fill_in 'パスワード確認', with: 'password'
  #       click_button 'ユーザー登録'
  #       expect(page).to have_selector 'div.alert.alert-success'
  #     end
  #   end
  # end
end
