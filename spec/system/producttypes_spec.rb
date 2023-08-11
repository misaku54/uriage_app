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

    describe 'ページ遷移確認' do
      context 'ユーザーAでログインしている場合' do
        let(:login_user) { user_a }

        context 'ユーザーAに紐づく商品分類の一覧画面へアクセス' do
          it '正常に遷移すること' do
            visit user_producttypes_path(login_user)
            expect(page).to have_current_path user_producttypes_path(login_user)
          end
        end

        context 'ユーザーAに紐づく商品分類の新規登録画面へアクセス' do
          it '正常に遷移すること' do
            visit new_user_producttype_path(login_user)
            expect(page).to have_current_path new_user_producttype_path(login_user)
          end
        end

        context 'ユーザーAに紐づく商品分類の編集画面へアクセス' do
          it '正常に遷移すること' do
            visit edit_user_producttype_path(login_user, producttype)
            expect(page).to have_current_path edit_user_producttype_path(login_user, producttype)
          end
        end
      end

      context 'ユーザーBでログインしている場合' do
        let(:login_user) { user_b }

        context 'ユーザーAに紐づく商品分類の一覧画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit user_producttypes_path(user_a)
            expect(page).to have_current_path root_path
          end
        end
        context 'ユーザーAに紐づく商品分類の新規登録画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit new_user_producttype_path(user_a)
            expect(page).to have_current_path root_path
          end
        end
        context 'ユーザーAに紐づく商品分類の編集画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit edit_user_producttype_path(user_a, producttype)
            expect(page).to have_current_path root_path
          end
        end
      end
    end


    describe '一覧表示機能' do
      before do
        visit user_producttypes_path(login_user)
      end

      describe '表示機能' do
        context 'ユーザーAでログインしている場合' do
          let(:login_user) { user_a }

          it 'ユーザーAが登録した商品が表示されていること' do
            expect(page).to have_content '商品A'
            expect(page).to have_link nil, href: "/users/#{producttype.user.id}/producttypes/#{producttype.id}/edit"
            expect(page).to have_link nil, href: "/users/#{producttype.user.id}/producttypes/#{producttype.id}"
          end
        end

        context 'ユーザーBでログインしている場合' do
          let(:login_user) { user_b }

          it 'ユーザーAが登録した商品が表示されていないこと' do
            expect(page).to have_no_content '商品A'
            expect(page).to have_no_link nil, href: "/users/#{producttype.user.id}/producttypes/#{producttype.id}/edit"
            expect(page).to have_no_link nil, href: "/users/#{producttype.user.id}/producttypes/#{producttype.id}"
          end
        end
      end

      describe '検索機能' do
        let(:login_user) { user_a }
        let!(:producttype_b) { FactoryBot.create(:producttype, name:'商品B', created_at: Time.zone.local(2023, 4, 1), user: user_a) }
        let!(:producttype_c) { FactoryBot.create(:producttype, name:'商品C', created_at: Time.zone.local(2023, 4, 10), user: user_a) }
        
        context '名前検索（部分一致）' do
          it '商品Aが表示されること' do
            fill_in 'q[name_cont]', with: 'A'
            click_button '検索'
            expect(page).to have_content '商品A'
            expect(page).to have_no_content '商品B'
          end
        end

        context '日付検索（範囲指定）' do
          it '商品BとCが表示されること' do
            fill_in 'q[created_at_gteq]', with: '002023-04-01'
            fill_in 'q[created_at_lteq_end_of_day]', with: '002023-04-30'
            click_button '検索'
            expect(page).to have_content '商品B'
            expect(page).to have_content '商品C'
            expect(page).to have_no_content '商品A'
          end
        end
      end
    end


    describe '新規登録機能' do
      let(:login_user) { user_a }

      before do
        visit new_user_producttype_path(login_user)
      end

      context '商品分類名を有効な値で登録した場合' do
        it '登録に成功する' do
          fill_in 'producttype[name]', with: 'create商品'
          expect {
            click_button '登録'
          }.to change(Producttype, :count).by(1)
          # 一覧画面へ遷移していること
          expect(page).to have_current_path user_producttypes_path(login_user)
          # 成功時のフラッシュが表示されていること
          expect(page).to have_selector 'div.alert.alert-success'
          # 登録した商品分類名が表示されていること
          expect(page).to have_content 'create商品'

          # 売上登録画面のセレクトボックスに商品分類名が反映されていること
          visit new_user_sale_path(login_user)
          expect(page).to have_content 'create商品'
        end
      end

      context '商品分類名を無効な値で登録した場合' do
        it '登録に失敗する' do
          fill_in 'producttype[name]', with: ''
          # DB上に登録されていないこと
          expect {
            click_button '登録'
          }.to_not change(Producttype, :count)
          # エラーメッセージが表示されていること
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end
    end


    describe '編集機能' do
      let(:login_user) { user_a }

      context '商品分類名を有効な値で更新した場合' do
        it '更新に成功する' do
          visit edit_user_producttype_path(login_user, producttype)
          fill_in 'producttype[name]', with: 'update商品'
          click_button '更新'
          # 正しい値に更新されているか
          producttype.reload
          expect(producttype.name).to eq 'update商品'
          # 一覧画面へ遷移していること
          expect(page).to have_current_path user_producttypes_path(login_user)
          # 成功時のフラッシュが表示されていること
          expect(page).to have_selector 'div.alert.alert-success'
          # 更新した商品が表示されていること
          expect(page).to have_content 'update商品'
          # 売上登録画面のセレクトボックスに商品分類が反映されていること
          visit new_user_sale_path(login_user)
          expect(page).to have_content 'update商品'
        end
      end

      context '商品分類名を無効な値で更新した場合' do
        it '更新に失敗する' do
          producttype_before = producttype
          visit edit_user_producttype_path(login_user, producttype)
          fill_in 'producttype[name]', with: ''
          click_button '更新'
          producttype.reload
          # 更新前と値が変わっていないこと
          expect(producttype).to be producttype_before
          # エラーメッセージが表示されること
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end
    end


    describe '削除機能' do
      let(:login_user) { user_a }

      context '一覧画面で削除ボタンをクリックした場合' do
        it '削除に成功する' do
          visit user_producttypes_path(login_user)
          expect {
            find("a[href='/users/#{producttype.user.id}/producttypes/#{producttype.id}']").click
          }.to change(Producttype, :count).by(-1)
          # 一覧画面へ遷移していること
          expect(page).to have_current_path user_producttypes_path(login_user)
          # 削除した商品分類名が表示されていないこと
          expect(page).to have_no_content '商品A'
          # 売上登録画面のセレクトボックスから商品分類名が削除されていること
          visit new_user_sale_path(login_user)
          expect(page).to have_no_content '商品A'
        end
      end
    end
  end
end
