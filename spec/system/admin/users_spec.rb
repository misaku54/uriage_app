require 'rails_helper'

RSpec.describe "ユーザー管理機能（管理者）", type: :system do
  let!(:admin_user) { FactoryBot.create(:admin_user) }
  let!(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
  let!(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
  
  describe '未ログイン' do
    describe 'ページ遷移確認' do
      context 'ユーザー一覧画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit admin_users_path
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context 'ユーザー詳細画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit admin_user_path(admin_user)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context 'ユーザー登録画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit new_admin_user_path
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context 'ユーザー編集画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit edit_admin_user_path(:user_a)
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

    describe 'ページ遷移確認' do
      context '一般ユーザーでログイン時' do
        let(:login_user) { user_a }

        context 'ユーザー一覧画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit admin_users_path
            expect(page).to have_current_path root_path
          end
        end

        context 'ユーザー詳細画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit admin_user_path(user_a)
            expect(page).to have_current_path root_path
          end
        end

        context 'ユーザー登録画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit admin_signup_path
            expect(page).to have_current_path root_path
          end
        end

        context 'ユーザー編集画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit edit_admin_user_path(user_a)
            expect(page).to have_current_path root_path
          end
        end
      end

      context '管理者でログイン時' do
        let(:login_user) { admin_user }

        context 'ユーザー一覧画面へアクセス' do
          it '正常に遷移すること' do
            visit admin_users_path
            expect(page).to have_current_path admin_users_path
          end
        end

        context 'ユーザー詳細画面へアクセス' do
          it '正常に遷移すること' do
            visit admin_user_path(admin_user)
            expect(page).to have_current_path admin_user_path(admin_user)
          end
        end

        context 'ユーザー登録画面へアクセス' do
          it '正常に遷移すること' do
            visit admin_signup_path
            expect(page).to have_current_path admin_signup_path
          end
        end

        context 'ユーザー編集画面へアクセス' do
          it '正常に遷移すること' do
            visit edit_admin_user_path(admin_user)
            expect(page).to have_current_path edit_admin_user_path(admin_user)
          end
        end
      end 
    end

    describe '一覧表示機能' do
      context '管理者でログイン時' do
        let(:login_user) { admin_user }
        before do
          visit admin_users_path
        end
        it 'ユーザーA、ユーザーBの情報が表示されていること' do
          expect(page).to have_content 'ユーザーA'
          expect(page).to have_content 'a@example.com'
          expect(page).to have_content 'ユーザーB'
          expect(page).to have_content 'b@example.com'
        end

        it '自分（管理者）のアカウントには編集ボタンと削除ボタンが表示されていないこと' do
          #リンクがないとき
          expect(page).to have_no_link '編集', href: "/admin/users/#{login_user.id}/edit"
          expect(page).to have_no_link '削除', href: "/admin/users/#{login_user.id}"
        end
      end
    end

    describe '新規登録機能' do
      context '管理者でログイン時' do
        let(:login_user) { admin_user }
        before do
          visit admin_signup_path
        end

        context 'ユーザー名を有効な値で登録した場合' do
          it '登録に成功する' do
            fill_in '名前', with: 'ユーザーC'
            fill_in 'メールアドレス', with: 'c@example.com'
            fill_in 'パスワード', with: 'password'
            fill_in 'パスワード確認', with: 'password'
            # DB上に登録されていること
            expect {
              click_button 'ユーザー登録'
            }.to change(User, :count).by(1)
            create_user = User.last
            # 登録したユーザーの詳細画面へ遷移していること
            expect(page).to have_current_path admin_user_path(create_user)
            # 成功時のフラッシュが表示されていること
            expect(page).to have_selector 'div.alert.alert-success'
            # 登録したユーザーが表示されていること
            expect(page).to have_content 'ユーザーC'
            expect(page).to have_content 'c@example.com'
          end
        end

        context 'ユーザー名を無効な値で登録した場合' do
          it '登録に失敗する' do
            fill_in '名前', with: ''
            fill_in 'メールアドレス', with: 'user@invalid'
            fill_in 'パスワード', with: 'foo'
            fill_in 'パスワード確認', with: 'bar'
            # DB上に登録されていないこと
            expect {
              click_button 'ユーザー登録'
            }.to_not change(User, :count)
            # エラーメッセージが表示されていること
            # renderの挙動を確認する方法がわからなかったため、have_selectorを使用
            expect(page).to have_selector 'h1', text: 'ユーザー登録'
            expect(page).to have_selector 'div.alert.alert-danger'
          end
        end
      end
    end

    describe '編集機能' do
      context '管理者でログイン時' do
        let(:login_user) { admin_user }
        before do
          visit edit_admin_user_path(user_a)
        end

        context 'ユーザーAを有効な値で更新した場合' do
          it '更新に成功する' do
            fill_in '名前', with: 'ユーザーD'
            fill_in 'メールアドレス', with: 'd@example.com'
            fill_in 'パスワード', with: 'validpassword'
            fill_in 'パスワード確認', with: 'validpassword'
            click_button 'ユーザー更新'

            # 正しい値に更新されているか
            user_a.reload
            expect(user_a.name).to eq 'ユーザーD'
            expect(user_a.email).to eq 'd@example.com'
            expect(user_a.authenticate('validpassword')).to be_truthy
          end
        end

        context 'ユーザーAを無効な値で更新した場合' do
          it '更新に失敗する' do
            user_before = user_a
            fill_in '名前', with: ''
            fill_in 'メールアドレス', with: 'user@invalid'
            fill_in 'パスワード', with: 'foo'
            fill_in 'パスワード確認', with: 'bar'
            click_button 'ユーザー更新'
            user_a.reload
            # 更新前と値が変わっていないこと
            expect(user_a).to be user_before
            # エラーメッセージが表示されること
            expect(page).to have_selector 'div.alert.alert-danger'
          end
        end
      end
    end
  end
end