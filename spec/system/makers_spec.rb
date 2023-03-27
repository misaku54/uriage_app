require 'rails_helper'

RSpec.describe "メーカー管理機能", type: :system do
  describe '一覧表示機能' do
    let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 
    let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') } 
    let!(:maker) { FactoryBot.create(:maker, name:'メーカーA', user: user_a) }

    context '未ログイン' do
      it 'ログイン画面に遷移し、フラッシュが表示されること' do
        visit user_makers_path(user_a)
        expect(page).to have_current_path login_path
        expect(page).to have_selector 'div.alert.alert-danger'
      end
    end

    context 'ユーザーAでログインしている場合' do
      it 'ユーザーAが作成したメーカーが表示されていること' do
        visit login_path
        fill_in 'メールアドレス', with: user_a.email
        fill_in 'パスワード', with: user_a.password
        click_button 'ログイン'
        visit user_makers_path(user_a)
        expect(page).to have_content 'メーカーA'
      end
    end

    context 'ユーザーBでログインしている場合' do
      it 'ユーザーAが作成したメーカーが表示されていないこと' do
        visit login_path
        fill_in 'メールアドレス', with: user_b.email
        fill_in 'パスワード', with: user_b.password
        click_button 'ログイン'
        visit user_makers_path(user_a)
        expect(page).to_not have_content 'メーカーA'
      end
    end
  end
end
