require 'rails_helper'

RSpec.describe "メーカー管理機能", type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') } 
  let!(:maker) { FactoryBot.create(:maker, name:'メーカーA', user: user_a) }
  
  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
  end

  describe '一覧表示機能' do
    context 'ユーザーAでログインしている場合' do
      let(:login_user) { user_a }

      it 'ユーザーAが作成したメーカーが表示されていること' do
        visit user_makers_path(login_user)
        expect(page).to have_content 'メーカーA'
      end
    end

    context 'ユーザーBでログインしている場合' do
      let(:login_user) { user_b }
      
      it 'ユーザーAが作成したメーカーが表示されていないこと' do
        visit user_makers_path(login_user)
        expect(page).to_not have_content 'メーカーA'
      end
    end

    context 'ユーザーAでログインし、ユーザーBの一覧画面へ遷移した場合' do
      let(:login_user) { user_a }

      it 'ホーム画面へ遷移すること' do
        visit user_makers_path(user_b)
        expect(page).to have_current_path root_path
      end
    end
  end

  describe '新規登録機能' do
    context '新規登録画面でメーカー名を入力した時' do
      let(:login_user) { user_a }
      
      it '正常に登録され、一覧画面へ遷移すること' do
        visit user_makers_path(user_a)
        expect(page).to have_current_path login_path
        expect(page).to have_selector 'div.alert.alert-danger'
      end
    end
  end
end
