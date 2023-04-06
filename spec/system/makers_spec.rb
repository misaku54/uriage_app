require 'rails_helper'

RSpec.describe "メーカー管理機能", type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') } 
  let!(:maker) { FactoryBot.create(:maker, name:'メーカーA', user: user_a) }
  
  describe '未ログイン' do
    describe 'ページ遷移確認' do
      context 'メーカーの一覧画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit user_makers_path(user_a)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context 'メーカーの新規登録画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit new_user_maker_path(user_a)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context 'メーカーの編集画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit edit_user_maker_path(user_a, maker)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end
    end
  end

  describe 'ログイン中' do
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
    end

    describe '新規登録機能' do
      let(:login_user) { user_a }

      context 'メーカー名を有効な値で登録した場合' do
        it '登録に成功する' do
          visit new_user_maker_path(login_user)
          fill_in 'メーカー名', with: 'createメーカー'
          expect {
            click_button 'メーカー登録'
          }.to change(Maker, :count).by(1)
          # 一覧画面へ遷移していること
          expect(page).to have_current_path user_makers_path(login_user)
          # 成功時のフラッシュが表示されていること
          expect(page).to have_selector 'div.alert.alert-success'
          # 登録したメーカーが表示されていること
          expect(page).to have_content 'createメーカー'

          # 売上登録画面のセレクトボックスにメーカー名が反映されていること
          visit new_user_sale_path(login_user)
          expect(page).to have_content 'createメーカー'
        end
      end

      context 'メーカー名を無効な値で登録した場合' do
        it '登録に失敗する' do
          visit new_user_maker_path(login_user)
          fill_in 'メーカー名', with: ''
          # DB上に登録されていないこと
          expect {
            click_button 'メーカー登録'
          }.to_not change(Maker, :count)
          # エラーメッセージが表示されていること
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end
    end

    describe '編集機能' do
      let(:login_user) { user_a }

      context 'メーカー名を有効な値で更新した場合' do
        it '更新に成功する' do
          visit edit_user_maker_path(login_user, maker)
          fill_in 'メーカー名', with: 'updateメーカー'
          click_button 'メーカー修正'

          # 正しい値に更新されているか
          maker.reload
          expect(maker.name).to eq 'updateメーカー'
          # 一覧画面へ遷移していること
          expect(page).to have_current_path user_makers_path(login_user)
          # 成功時のフラッシュが表示されていること
          expect(page).to have_selector 'div.alert.alert-success'
          # 更新したメーカーが表示されていること
          expect(page).to have_content 'updateメーカー'

          # 売上登録画面のセレクトボックスにメーカー名が反映されていること
          visit new_user_sale_path(login_user)
          expect(page).to have_content 'updateメーカー'
        end
      end

      context 'メーカー名を無効な値で更新した場合' do
        it '更新に失敗する' do
          maker_before = maker
          visit edit_user_maker_path(login_user, maker)
          fill_in 'メーカー名', with: ''
          click_button 'メーカー修正'
          maker.reload
          # 更新前と値が変わっていないこと
          expect(maker).to be maker_before
          # エラーメッセージが表示されること
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end
    end

    describe '削除機能' do
      let(:login_user) { user_a }

      context '一覧画面で削除ボタンをクリックした場合' do
        it '削除に成功する' do
          visit user_makers_path(login_user)
          # DB上で削除されていること
          expect {
            click_link '削除'
          }.to change(Maker, :count).by(-1)
          # 一覧画面へ遷移していること
          expect(page).to have_current_path user_makers_path(login_user)
          # 削除したメーカーが表示されていないこと
          expect(page).to_not have_content 'メーカーA'

          # 売上登録画面のセレクトボックスからメーカー名が削除されていること
          visit new_user_sale_path(login_user)
          expect(page).to_not have_content 'メーカーA'
        end
      end
    end
  end
end
