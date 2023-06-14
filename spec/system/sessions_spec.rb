require 'rails_helper'

RSpec.describe "セッション機能", type: :system do

  describe 'ログイン機能' do
    context '無効な値でログインした場合' do
      it 'ログインできないこと' do
        visit login_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        click_button 'ログイン'
        # ログインページにレンダリングされていること
        expect(page).to have_current_path login_path
        # フラッシュが表示されていること
        expect(page).to have_selector 'div.alert.alert-danger'
        # ページ遷移後、フラッシュが表示されていないこと
        visit root_path
        expect(page).to_not have_selector 'div.alert.alert-danger'
      end
    end

    context '有効な値でログインした場合' do
      let(:user) { FactoryBot.create(:user) }
      
      before do
        log_in(user)
      end

      it 'ログインできること' do
        # ユーザー詳細ページに遷移されること
        expect(page).to have_current_path user_path(user)
        # ページに適切な項目が表示されていること
        expect(page).to have_content '売上一覧'
        expect(page).to have_content '運用管理'
        expect(page).to have_content '商品マスタ'
        expect(page).to have_content 'メーカーマスタ'
        expect(page).to have_content "#{user.name}"
        expect(page).to have_content 'ユーザー情報'
        expect(page).to have_content 'ログアウト'
      end

      it 'ログアウトできること' do
        click_link 'ログアウト'
        # ページに適切な項目が表示されていること
        expect(page).to have_content 'ログイン'
        expect(page).to have_no_content '売上一覧'
        expect(page).to have_no_content '運用管理'
        expect(page).to have_no_content '商品マスタ'
        expect(page).to have_no_content 'メーカーマスタ'
        expect(page).to have_no_content "#{user.name}"
        expect(page).to have_no_content 'ユーザー情報'
        expect(page).to have_no_content 'ユーザー編集'
        expect(page).to have_no_content 'ログアウト'
      end
    end
  end
end
