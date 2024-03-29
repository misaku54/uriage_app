require 'rails_helper'

RSpec.describe "メーカー管理機能", type: :system do
  let!(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 
  let!(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') } 
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
      log_in(login_user)
    end

    describe 'ページ遷移確認' do
      context 'ユーザーAでログインしている場合' do
        let(:login_user) { user_a }

        context 'ユーザーAに紐づくメーカーの一覧画面へアクセス' do
          it '正常に遷移すること' do
            visit user_makers_path(login_user)
            expect(page).to have_current_path user_makers_path(login_user)
          end
        end

        context 'ユーザーAに紐づくメーカーの新規登録画面へアクセス' do
          it '正常に遷移すること' do
            visit new_user_maker_path(login_user)
            expect(page).to have_current_path new_user_maker_path(login_user)
          end
        end

        context 'ユーザーAに紐づくメーカーの編集画面へアクセス' do
          it '正常に遷移すること' do
            visit edit_user_maker_path(login_user, maker)
            expect(page).to have_current_path edit_user_maker_path(login_user, maker)
          end
        end
      end

      context 'ユーザーBでログインしている場合' do
        let(:login_user) { user_b }

        context 'ユーザーAに紐づくメーカーの一覧画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit user_makers_path(user_a)
            expect(page).to have_current_path root_path
          end
        end
        context 'ユーザーAに紐づくメーカーの新規登録画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit new_user_maker_path(user_a)
            expect(page).to have_current_path root_path
          end
        end
        context 'ユーザーAに紐づくメーカーの編集画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit edit_user_maker_path(user_a, maker)
            expect(page).to have_current_path root_path
          end
        end
      end
    end


    describe '一覧表示機能' do
      before do
        visit user_makers_path(login_user)
      end

      describe '表示機能' do
        context 'ユーザーAでログインしている場合' do
          let(:login_user) { user_a }

          it 'ユーザーAが作成したメーカーが表示されていること' do
            expect(page).to have_content 'メーカーA'
            expect(page).to have_link nil, href: "/users/#{maker.user.id}/makers/#{maker.id}/edit" 
            expect(page).to have_selector "form[action='/users/#{maker.user.id}/makers/#{maker.id}']"
          end
        end

        context 'ユーザーBでログインしている場合' do
          let(:login_user) { user_b }

          it 'ユーザーAが作成したメーカーが表示されていないこと' do
            expect(page).to have_no_content 'メーカーA'
            expect(page).to have_no_link nil, href: "/users/#{maker.user.id}/makers/#{maker.id}/edit"
            expect(page).to have_no_selector "form[action='/users/#{maker.user.id}/makers/#{maker.id}']"
          end
        end
      end

      describe '検索機能' do
        let(:login_user) { user_a }
        let!(:maker_b) { FactoryBot.create(:maker, name:'メーカーB', created_at: Time.zone.local(2023, 4, 1), user: user_a) }
        let!(:maker_c) { FactoryBot.create(:maker, name:'メーカーC', created_at: Time.zone.local(2023, 4, 10), user: user_a) }

        context '名前検索（部分一致）' do
          it 'メーカーAが表示されること' do
            fill_in 'q[name_cont]', with: 'A'
            click_button '検索'
            expect(page).to have_content 'メーカーA'
            expect(page).to have_no_content 'メーカーB'
          end
        end

        context '日付検索（範囲指定）' do
          it 'メーカーBとCが表示されること' do
            fill_in 'q[created_at_gteq]', with: '002023-04-01'
            fill_in 'q[created_at_lteq_end_of_day]', with: '002023-04-30'
            click_button '検索'
            expect(page).to have_content 'メーカーB'
            expect(page).to have_content 'メーカーC'
            expect(page).to have_no_content 'メーカーA'
          end
        end
      end

      describe 'CSV出力機能' do
        let(:login_user) { user_a }

        it '正しい名前でCSVが出力されていること' do
          click_button 'CSV出力'
          expect(page.response_headers["Content-Type"]).to include "text/csv"
          expect(page.response_headers['Content-Disposition']).to include("#{Time.zone.now.strftime('%Y%m%d')}_makers.csv")
        end
      end
    end


    describe '新規登録機能' do
      let(:login_user) { user_a }

      context 'メーカー名を有効な値で登録した場合' do
        it '登録に成功する' do
          visit new_user_maker_path(login_user)
          fill_in 'maker[name]', with: 'createメーカー'
          # DB上に登録されていること
          expect {
            click_button '登録'
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
          fill_in 'maker[name]', with: ''
          # DB上に登録されていないこと
          expect {
            click_button '登録'
          }.to_not change(Maker, :count)
          # エラーメッセージが表示されていること
          expect(page).to have_selector '#error_explanation'
        end
      end
    end


    describe '編集機能' do
      let(:login_user) { user_a }

      context 'メーカー名を有効な値で更新した場合' do
        it '更新に成功する' do
          visit edit_user_maker_path(login_user, maker)
          fill_in 'maker[name]', with: 'updateメーカー'
          click_button '更新'

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
          fill_in 'maker[name]', with: ''
          click_button '更新'
          maker.reload
          # 更新前と値が変わっていないこと
          expect(maker).to be maker_before
          # エラーメッセージが表示されること
          expect(page).to have_selector '#error_explanation'
        end
      end
    end

    
    describe '削除機能' do
      let(:login_user) { user_a }

      context '一覧画面で削除ボタンをクリック' do
        before do
          visit user_makers_path(login_user)
        end

        context '関連データがないデータの場合' do
          it '削除に成功する' do
            # DB上で削除されていること
            expect {
              find("form[action='/users/#{maker.user.id}/makers/#{maker.id}']").find('button').click
            }.to change(Maker, :count).by(-1)
            # 一覧画面へ遷移していること
            expect(page).to have_current_path user_makers_path(login_user)
            # 削除したメーカーが表示されていないこと
            expect(page).to have_no_content 'メーカーA'

            # 売上登録画面のセレクトボックスからメーカー名が削除されていること
            visit new_user_sale_path(login_user)
            expect(page).to have_no_content 'メーカーA'
          end
        end
        
        context '関連データがあるデータの場合' do
          let!(:weather) { FactoryBot.create(:weather) }
          let!(:producttype) { FactoryBot.create(:producttype, name:'商品A', user: user_a) }
          let!(:sale) { FactoryBot.create(:sale, maker: maker, producttype: producttype, user: user_a) }
          
          it '削除に失敗する' do
            expect {
              find("form[action='/users/#{maker.user.id}/makers/#{maker.id}']").find('button').click
            }.to change(Maker, :count).by(0)
            # 一覧画面へ遷移していること
            expect(page).to have_current_path user_makers_path(login_user)
            # 削除したメーカーが表示されること
            expect(page).to have_content 'メーカーA'
            # 失敗時のフラッシュが表示されること
            expect(page).to have_selector 'div.alert.alert-danger'
            # 売上登録画面のセレクトボックスからメーカー名が削除されていないこと
            visit new_user_sale_path(login_user)  
            expect(page).to have_content 'メーカーA'
          end
        end
      end
    end
  end
end
