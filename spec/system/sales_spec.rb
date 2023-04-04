require 'rails_helper'

RSpec.describe "売上管理機能", type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') } 
  let!(:sale) { FactoryBot.create(:sale, user: user_a) }


  describe '未ログイン' do
    describe 'ページ遷移確認' do
      context '売上一覧画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit user_sales_path(user_a)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context '売上の新規登録画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit user_sales_path(user_a)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end
    end
  end

  describe 'ログイン中' do
    before do
      log_in(login_user)
    end
  
    describe '一覧表示機能' do
      context 'ユーザーAでログインしている場合' do
        let(:login_user) { user_a }

        it 'ユーザーAが登録した売上情報が表示されていること' do
          visit user_sales_path(login_user)
          expect(page).to have_content 'テスト会社'
          expect(page).to have_content 'カバン'
          expect(page).to have_content '10000'
          expect(page).to have_content '期間限定商品'
        end
      end

      context 'ユーザーBでログインしている場合' do
        let(:login_user) { user_b }

        it 'ユーザーAが登録した売上情報が表示されていないこと' do
          visit user_sales_path(login_user)
          expect(page).to_not have_content 'テスト会社'
          expect(page).to_not have_content 'カバン'
          expect(page).to_not have_content '10000'
          expect(page).to_not have_content '期間限定商品'
        end
      end
    end

    describe '新規登録機能' do
      let(:login_user) { user_a }
      
      context '売上情報を有効な値で登録した場合' do
        it '登録に成功する' do
          visit new_user_sale_path(login_user)
          select 'テスト会社', from: 'sale[maker_id]'
          select 'カバン', from: 'sale[producttype_id]'
          fill_in '販売価格', with: 50000
          fill_in '備考', with: 'セール価格'
          # DB上に登録されていること
          expect {
            click_button '売上登録'
          }.to change(Sale, :count).by(1)

          # 一覧画面へ遷移していること
          expect(page).to have_current_path user_sales_path(login_user)
          # 成功時のフラッシュが表示されていること
          expect(page).to have_selector 'div.alert.alert-success'
          # 一覧画面に、登録した売上情報が反映されていること
          expect(page).to have_content 'テスト会社'
          expect(page).to have_content 'カバン'
          expect(page).to have_content '50000'
          expect(page).to have_content 'セール価格'
        end
      end
      
      context '売上情報を無効な値で登録した場合' do
        it '登録に失敗する' do
          visit new_user_sale_path(login_user)
          select 'テスト会社', from: 'sale[maker_id]'
          select 'カバン', from: 'sale[producttype_id]'
          fill_in '販売価格', with: 0
          fill_in '備考', with: ''
          # DB上に登録されていないこと
          expect {
            click_button '売上登録'
          }.to_not change(Sale, :count)
          # エラーメッセージが表示されていること
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end
    end
  end
end
