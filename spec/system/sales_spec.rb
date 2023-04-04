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
          expect(page).to have_content '期間限定商品'
          expect(page).to have_content 'テスト会社'
          expect(page).to have_content 'カバン'
        end
      end

      context 'ユーザーBでログインしている場合' do
        let(:login_user) { user_b }

        it 'ユーザーAが登録した売上情報が表示されていないこと' do
          visit user_sales_path(login_user)
          expect(page).to_not have_content '期間限定商品'
          expect(page).to_not have_content 'テスト会社'
          expect(page).to_not have_content 'カバン'
        end
      end
    end

    describe '新規登録機能' do
      let(:login_user) { user_a }
      
      context '売上情報を有効な値で登録した場合' do
        it '正常に登録され、一覧画面へ遷移後、フラッシュが表示されること' do
          visit new_user_sales_path(login_user)
          select 'テスト会社', from: 'sale[maker_id]'
          select 'カバン', from: 'sale[producttype_id]'
          fill_in '販売価格', with: 50000
          fill_in '備考', with: 'セール価格'
        end
      end
    end
  end
end
