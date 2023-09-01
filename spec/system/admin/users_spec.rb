require 'rails_helper'

RSpec.describe "ユーザー管理機能（管理者）", type: :system do
  let!(:admin_user) { FactoryBot.create(:admin_user) }
  let!(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }

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
      log_in(login_user)
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
    
    describe '詳細表示機能' do
      let(:login_user) { admin_user }

      context 'ユーザーAの詳細画面へアクセス' do
        it 'ユーザーAの情報が表示されていること' do
          visit admin_user_path(user_a)
          expect(page).to have_selector 'td', text: user_a.id
          expect(page).to have_selector 'td', text: user_a.name
          expect(page).to have_selector 'td', text: user_a.email
        end
      end
    end

    describe '一覧表示機能' do
      let(:login_user) { admin_user }
      let!(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
      
      before do
        visit admin_users_path
      end

      describe '表示機能' do
        it 'ユーザーA、ユーザーBの情報が表示されていること' do
          expect(page).to have_content 'ユーザーA'
          expect(page).to have_content 'a@example.com'
          expect(page).to have_content 'ユーザーB'
          expect(page).to have_content 'b@example.com'
          expect(page).to have_link nil, href: "/admin/users/#{user_a.id}/edit"
          expect(page).to have_link nil, href: "/admin/users/#{user_a.id}"
          expect(page).to have_link nil, href: "/admin/users/#{user_b.id}/edit"
          expect(page).to have_link nil, href: "/admin/users/#{user_b.id}"
        end

        it '自分（管理者）のアカウントには編集ボタンと削除ボタンが表示されていないこと' do
          expect(page).to have_no_link '編集', href: "/admin/users/#{login_user.id}/edit"
          expect(page).to have_no_link '削除', href: "/admin/users/#{login_user.id}"
        end
      end

      describe '検索機能' do
        let!(:user_c) { FactoryBot.create(:user, name:'ユーザーC', email: 'c@example.com', created_at: Time.zone.local(2023, 4, 1), updated_at: Time.zone.local(2023, 4, 1)) }
        let!(:user_d) { FactoryBot.create(:user, name:'ユーザーD', email: 'd@example.com', created_at: Time.zone.local(2023, 4, 10), updated_at: Time.zone.local(2023, 4, 1)) }

        context '名前検索（部分一致）' do
          it 'ユーザーAが表示されること' do
            fill_in 'q[name_cont]', with: 'A'
            click_button '検索'
            expect(page).to have_content 'ユーザーA'
            expect(page).to have_no_content 'ユーザーB'
            expect(page).to have_no_content 'ユーザーC'
            expect(page).to have_no_content 'ユーザーD'
          end
        end

        context 'email検索（部分一致）' do
          it 'ユーザーAが表示されること' do
            fill_in 'q[email_cont]', with: 'a@example'
            click_button '検索'
            expect(page).to have_content 'ユーザーA'
            expect(page).to have_no_content 'ユーザーB'
            expect(page).to have_no_content 'ユーザーC'
            expect(page).to have_no_content 'ユーザーD'
          end
        end

        context '日付検索（範囲指定）' do
          context '登録日で検索' do
            it 'ユーザーCとDが表示されること' do
              fill_in 'q[created_at_gteq]', with: '002023-04-01'
              fill_in 'q[created_at_lteq_end_of_day]', with: '002023-04-30'
              click_button '検索'
              expect(page).to have_content 'ユーザーC'
              expect(page).to have_content 'ユーザーD'
              expect(page).to have_no_content 'ユーザーA'
              expect(page).to have_no_content 'ユーザーB'
            end
          end

          context '更新日で検索' do
            it 'ユーザーCとDが表示されること' do
              fill_in 'q[updated_at_gteq]', with: '002023-04-01'
              fill_in 'q[updated_at_lteq_end_of_day]', with: '002023-04-30'
              click_button '検索'
              expect(page).to have_content 'ユーザーC'
              expect(page).to have_content 'ユーザーD'
              expect(page).to have_no_content 'ユーザーA'
              expect(page).to have_no_content 'ユーザーB'
            end
          end
        end
      end
    end

    describe '新規登録機能' do
      let(:login_user) { admin_user }
      before do
        visit admin_signup_path
      end

      context 'ユーザー名を有効な値で登録した場合' do
        it '登録に成功する' do
          fill_in 'user[name]', with: 'ユーザーC'
          fill_in 'user[email]', with: 'c@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
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
          fill_in 'user[name]', with: ''
          fill_in 'user[email]', with: 'user@invalid'
          fill_in 'user[password]', with: 'foo'
          fill_in 'user[password_confirmation]', with: 'bar'
          # DB上に登録されていないこと
          expect {
            click_button 'ユーザー登録'
          }.to_not change(User, :count)
          # エラーメッセージが表示されていること
          # renderの挙動を確認する方法がわからなかったため、have_selectorを使用
          expect(page).to have_selector 'li', text: 'ユーザー登録'
          expect(page).to have_selector '#error_explanation'
        end
      end
    end

    describe '編集機能' do
      let(:login_user) { admin_user }
      before do
        visit edit_admin_user_path(user_a)
      end

      context 'ユーザーAを有効な値で更新した場合' do
        it '更新に成功する' do
          fill_in 'user[name]', with: 'ユーザーD'
          fill_in 'user[email]', with: 'd@example.com'
          fill_in 'user[password]', with: 'validpassword'
          fill_in 'user[password_confirmation]', with: 'validpassword'
          click_button 'ユーザー更新'
          # 正しい値に更新されているか
          user_a.reload
          expect(user_a.name).to eq 'ユーザーD'
          expect(user_a.email).to eq 'd@example.com'
          expect(user_a.authenticate('validpassword')).to be_truthy
        end
      end

      context 'ユーザーAに管理者権限を付与して更新した場合' do
        it '管理者権限が付与されていること' do
          check 'user[admin]'
          click_button 'ユーザー更新'
          
          user_a.reload
          expect(user_a.admin).to be_truthy
        end
      end

      context 'ユーザーAを無効な値で更新した場合' do
        it '更新に失敗する' do
          user_before = user_a
          fill_in 'user[name]', with: ''
          fill_in 'user[email]', with: 'user@invalid'
          fill_in 'user[password]', with: 'foo'
          fill_in 'user[password_confirmation]', with: 'bar'
          click_button 'ユーザー更新'
          user_a.reload
          # 更新前と値が変わっていないこと
          expect(user_a).to be user_before
          # エラーメッセージが表示されること
          expect(page).to have_selector '#error_explanation'
        end
      end
    end
    
    describe '削除機能' do
      let(:login_user) { admin_user }

      context '一覧画面で削除ボタンをクリックした場合' do
        it '削除に成功する' do
          visit admin_users_path
          # DB上で削除されていること
          expect {
            page.all("a[href='/admin/users/#{user_a.id}']")[1].click
          }.to change(User, :count).by(-1)
          # 一覧画面へ遷移していること
          expect(page).to have_current_path admin_users_path
          # 削除したメーカーが表示されていないこと
          expect(page).to have_no_content 'ユーザーA'
        end
      end
    end
  end
end