require 'rails_helper'

RSpec.describe "商品管理機能", type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') } 
  let!(:producttype) { FactoryBot.create(:producttype, name:'商品A', user: user_a) }
  
  describe '未ログイン' do
    describe 'ページ遷移確認' do
      context '商品の一覧画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit user_producttypes_path(user_a)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context '商品の新規登録画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit new_user_producttype_path(user_a)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context '商品の編集画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit edit_user_producttype_path(user_a, producttype)
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

        it 'ユーザーAが登録した商品が表示されていること' do
          visit user_producttypes_path(login_user)
          expect(page).to have_content '商品A'
        end
      end

      context 'ユーザーBでログインしている場合' do
        let(:login_user) { user_b }

        it 'ユーザーAが登録した商品が表示されていないこと' do
          visit user_producttypes_path(login_user)
          expect(page).to_not have_content '商品A'
        end
      end
    end

    describe '新規登録機能' do
      let(:login_user) { user_a }

      context '商品名を有効な値で登録した場合' do
        it '正常に登録され、一覧画面へ遷移後、フラッシュが表示されること' do
          visit new_user_producttype_path(login_user)
          fill_in '商品名', with: 'create商品'
          expect {
            click_button '商品登録'
          }.to change(Producttype, :count).by(1)
          expect(page).to have_current_path user_producttypes_path(login_user)
          expect(page).to have_selector 'div.alert.alert-success'
        end
      end

      context '商品名を無効な値で登録した場合' do
        it '登録されず、エラーとなること' do
          visit new_user_producttype_path(login_user)
          fill_in '商品名', with: ''
          expect {
            click_button '商品登録'
          }.to_not change(Producttype, :count)
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end
    end

    describe '編集機能' do
      let(:login_user) { user_a }

      context '商品名を有効な値で更新した場合' do
        it '正常に更新され、一覧画面へ遷移すること' do
          visit edit_user_producttype_path(login_user, producttype)
          fill_in '商品名', with: 'update商品'
          click_button '商品修正'
          producttype.reload
          expect(producttype.name).to eq 'update商品'
          expect(page).to have_current_path user_producttypes_path(login_user)
        end
      end

      context '商品名を変更せずに更新した場合' do
        it '更新されず、一覧画面へ遷移すること' do
          producttype_before = producttype
          visit edit_user_producttype_path(login_user, producttype)
          click_button '商品修正'
          producttype.reload
          expect(producttype).to be producttype_before
          expect(page).to have_current_path user_producttypes_path(login_user)
        end
      end

      context '商品名を無効な値で更新した場合' do
        it '更新されず、エラーとなること' do
          producttype_before = producttype
          visit edit_user_producttype_path(login_user, producttype)
          fill_in '商品名', with: ''
          click_button '商品修正'
          producttype.reload
          expect(producttype).to be producttype_before
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end
    end

    describe '削除機能' do
      let(:login_user) { user_a }

      context '一覧画面で削除ボタンをクリックした場合' do
        it '削除され、一覧画面へ遷移すること' do
          visit user_producttypes_path(login_user)
          expect {
            click_link '削除'
          }.to change(Producttype, :count).by(-1)
          expect(page).to have_current_path user_producttypes_path(login_user)
        end
      end
    end
  end
end
