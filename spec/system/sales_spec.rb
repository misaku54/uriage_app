require 'rails_helper'

RSpec.describe "売上管理機能", type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') } 
  let!(:sale) { FactoryBot.create(:sale, user: user_a) }

  describe '未ログイン' do
    describe 'ページ遷移確認' do

    end
  end
  
  describe 'ログイン中' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログイン'
    end
  
    describe '新規登録機能' do
      let(:login_user) { user_a }

      context '有効な値で登録した場合' do

      end
    end
  end
end
