require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'ログイン機能' do
    context '無効な値でログインした場合' do
      it 'flashメッセージが表示されていること' do
        visit login_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        click_button 'ログイン'
        expect(page).to have_selector 'div.alert.alert-danger'
        visit root_path
        expect(page).to_not have_selector 'div.alert.alert-danger'
      end
    end

    context '有効な値でログインした場合' do
      let(:user) { FactoryBot.create(:user) }
      before do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
      end

      it 'ページに適切な項目が表示されていること' do
        aggregate_failures do
          expect(page).to_not have_content 'ログイン'
          expect(page).to have_content '売上一覧'
          expect(page).to have_content '運用管理'
          expect(page).to have_content '商品マスタ'
          expect(page).to have_content 'メーカーマスタ'
          expect(page).to have_content "#{user.name}"
          expect(page).to have_content 'ユーザー情報'
          expect(page).to have_content 'ユーザー編集'
          expect(page).to have_content 'ログアウト'
        end
      end

      it 'ログアウト後、ページに適切な項目が表示されていること' do
        click_link 'ログアウト'
        aggregate_failures do
          expect(page).to have_content 'ログイン'
          expect(page).to_not have_content '売上一覧'
          expect(page).to_not have_content '運用管理'
          expect(page).to_not have_content '商品マスタ'
          expect(page).to_not have_content 'メーカーマスタ'
          expect(page).to_not have_content "#{user.name}"
          expect(page).to_not have_content 'ユーザー情報'
          expect(page).to_not have_content 'ユーザー編集'
          expect(page).to_not have_content 'ログアウト'
        end
      end
    end
  end
end
