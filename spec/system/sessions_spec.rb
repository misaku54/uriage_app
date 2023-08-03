require 'rails_helper'

RSpec.describe "セッション機能", type: :system do

  describe 'ログイン機能' do
    context '無効な値でログインした場合' do
      it 'ログインできないこと' do
        visit login_path
        fill_in 'session[email]', with: ''
        fill_in 'session[password]', with: ''
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
        expect(page).to have_current_path root_path
        # ページに適切な項目が表示されていること
        expect(page).to have_content "#{user.name}さん"
        expect(page).to have_content 'ユーザー情報'
        expect(page).to have_content 'ログアウト'
        expect(page).to have_content '日付'
        expect(page).to have_content '天気情報'
        expect(page).to have_content '本日の売上'
        expect(page).to have_content '売上一覧'
        expect(page).to have_css '.acordion'
        # 管理者用の項目が表示されていないこと
        expect(page).to have_no_content '管理者'
      end

      it 'ログアウトできること' do
        click_link 'ログアウト'
        # ページに適切な項目が表示されていること
        expect(page).to have_content 'ログイン'
        expect(page).to have_no_content "#{user.name}さん"
        expect(page).to have_no_content 'ユーザー情報'
        expect(page).to have_no_content 'ログアウト'
        expect(page).to have_no_content '日付'
        expect(page).to have_no_content '天気情報'
        expect(page).to have_no_content '本日の売上'
        expect(page).to have_no_content '売上一覧'
        expect(page).to have_no_css '.acordion'
      end
    end

    context '管理者でログインした場合' do
      let(:admin_user) { FactoryBot.create(:admin_user) }

      before do
        log_in(admin_user)
      end

      it '管理者用の項目が表示されていること' do
        # ユーザー詳細ページに遷移されること
        expect(page).to have_current_path root_path
        # ページに適切な項目が表示されていること
        expect(page).to have_content "#{admin_user.name}さん"
        expect(page).to have_content 'ユーザー情報'
        expect(page).to have_content 'ログアウト'
        expect(page).to have_content '日付'
        expect(page).to have_content '天気情報'
        expect(page).to have_content '本日の売上'
        expect(page).to have_content '売上一覧'
        expect(page).to have_css '.acordion'
        # 管理者用の項目が表示されていないこと
        expect(page).to have_content '管理者'
      end
    end
  end
end
