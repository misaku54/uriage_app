require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end
  
  describe '#create' do
    context '無効な値の場合' do
      it 'エラーメッセージが表示されていること' do
        visit signup_path
        fill_in '名前', with: ''
        fill_in 'メールアドレス', with: 'user@invlid'
        fill_in 'パスワード', with: 'foo'
        fill_in 'パスワード確認', with: 'bar'
        click_button 'ユーザー登録'
  
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end

    context '有効な値の場合' do
      it '成功用のフラッシュメッセージが表示されていること' do
        visit signup_path
        fill_in '名前', with: 'Example User'
        fill_in 'メールアドレス', with: 'user@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button 'ユーザー登録'
  
        expect(page).to have_selector 'div.alert.alert-success'
      end
    end
  end
end
