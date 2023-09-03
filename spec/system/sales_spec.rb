require 'rails_helper'

RSpec.describe "売上管理機能", type: :system do
  let!(:weather) { FactoryBot.create(:weather) }
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

      context '売上詳細画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit user_sale_path(user_a, sale)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context '売上新規登録画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit new_user_sale_path(user_a)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context '売上編集画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit edit_user_sale_path(user_a, sale)
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

        context 'ユーザーAに紐づく売上一覧画面へアクセス' do
          it '正常に遷移すること' do
            visit user_sales_path(login_user)
            expect(page).to have_current_path user_sales_path(login_user)
          end
        end

        context 'ユーザーAに紐づく売上詳細画面へアクセス' do
          it '正常に遷移すること' do
            visit user_sale_path(login_user, sale)
            expect(page).to have_current_path user_sale_path(login_user, sale)
          end
        end

        context 'ユーザーAに紐づく売上新規登録画面へアクセス' do
          it '正常に遷移すること' do
            visit new_user_sale_path(login_user)
            expect(page).to have_current_path new_user_sale_path(login_user)
          end
        end

        context 'ユーザーAに紐づく売上編集画面へアクセス' do
          it '正常に遷移すること' do
            visit edit_user_sale_path(login_user, sale)
            expect(page).to have_current_path edit_user_sale_path(login_user, sale)
          end
        end
      end

      context 'ユーザーBでログインしている場合' do
        let(:login_user) { user_b }

        context 'ユーザーAに紐づく売上一覧画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit user_sales_path(user_a)
            expect(page).to have_current_path root_path
          end
        end

        context 'ユーザーAに紐づく売上新規登録画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit new_user_sale_path(user_a)
            expect(page).to have_current_path root_path
          end
        end

        context 'ユーザーAに紐づく売上編集画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit edit_user_sale_path(user_a, sale)
            expect(page).to have_current_path root_path
          end
        end
      end
    end


    describe '一覧表示機能' do
      before do 
        visit user_sales_path(login_user)
      end

      describe '表示機能' do
        context 'ユーザーAでログインしている場合' do
          let(:login_user) { user_a }

          it 'ユーザーAが登録した売上情報が表示されていること' do
            expect(page).to have_content 'テスト会社'
            expect(page).to have_content 'カバン'
            expect(page).to have_content '10,000円'
            expect(page).to have_content '期間限定商品'
            expect(page).to have_link nil, href: "/users/#{sale.user.id}/sales/#{sale.id}/edit"
            expect(page).to have_link nil, href: "/users/#{sale.user.id}/sales/#{sale.id}"
          end
        end

        context 'ユーザーBでログインしている場合' do
          let(:login_user) { user_b }

          it 'ユーザーAが登録した売上情報が表示されていないこと' do
            expect(page).to have_no_content 'テスト会社'
            expect(page).to have_no_content 'カバン'
            expect(page).to have_no_content '10,000円'
            expect(page).to have_no_content '期間限定商品'
            expect(page).to have_no_link nil, href: "/users/#{sale.user.id}/sales/#{sale.id}/edit"
            expect(page).to have_no_link nil, href: "/users/#{sale.user.id}/sales/#{sale.id}"
          end
        end
      end

      describe '検索機能' do
        let(:login_user) { user_a }
        let!(:weather_b) { FactoryBot.create(:weather, aquired_on: Time.zone.local(2023, 4, 1)) }
        let!(:weather_c) { FactoryBot.create(:weather, aquired_on: Time.zone.local(2023, 4, 10)) }
        let!(:maker_b) { FactoryBot.create(:maker, name:'メーカーB', user: user_a) }
        let!(:producttype_b) { FactoryBot.create(:producttype, name:'商品B', user: user_a) }
        let!(:maker_c) { FactoryBot.create(:maker, name:'メーカーC', user: user_a) }
        let!(:producttype_c) { FactoryBot.create(:producttype, name:'商品C', user: user_a) }
        let!(:sale_b) { FactoryBot.create(:sale, amount_sold: 20000, remark: '備考B', created_at: Time.zone.local(2023, 4, 1), user: user_a, maker: maker_b, producttype: producttype_b) }
        let!(:sale_c) { FactoryBot.create(:sale, amount_sold: 30000, remark: '備考C', created_at: Time.zone.local(2023, 4, 10), user: user_a, maker: maker_c, producttype: producttype_c) }

        context 'メーカー名検索（部分一致）' do
          it '正しい売上データが表示されること' do
            fill_in 'q[maker_name_cont]', with: 'B'
            click_button '検索'
            expect(page).to have_content 'メーカーB'
            expect(page).to have_no_content 'メーカーC'
            expect(page).to have_no_content 'テスト会社'
          end
        end

        context '商品分類名検索（部分一致）' do
          it '正しい売上データが表示されること' do
            fill_in 'q[producttype_name_cont]', with: 'B'
            click_button '検索'
            expect(page).to have_content '商品B'
            expect(page).to have_no_content '商品C'
            expect(page).to have_no_content 'カバン'
          end
        end

        context '備考検索（部分一致）' do
          it '正しい売上データが表示されること' do
            fill_in 'q[remark_cont]', with: 'B'
            click_button '検索'
            expect(page).to have_content '備考B'
            expect(page).to have_no_content '備考C'
            expect(page).to have_no_content '期間限定商品'
          end
        end

        context '販売価格検索（範囲指定）' do
          it '正しい売上データが表示されること' do
            fill_in 'q[amount_sold_gteq]', with: 20000
            fill_in 'q[amount_sold_lteq]', with: 30000
            click_button '検索'
            expect(page).to have_content 'メーカーB'
            expect(page).to have_content 'メーカーC'
            expect(page).to have_no_content 'テスト会社'
          end
        end

        context '日付検索（範囲指定）' do
          it '正しい売上データが表示されること' do
            fill_in 'q[created_at_gteq]', with: '002023-04-01'
            fill_in 'q[created_at_lteq_end_of_day]', with: '002023-04-30'
            click_button '検索'
            expect(page).to have_content 'メーカーB'
            expect(page).to have_content 'メーカーC'
            expect(page).to have_no_content 'テスト会社'
          end
        end
      end

      describe 'CSV出力機能' do
        let(:login_user) { user_a }

        it '正しい名前でCSVが出力されていること' do
          click_button 'CSV出力'
          expect(page.response_headers["Content-Type"]).to include "text/csv"
          expect(page.response_headers['Content-Disposition']).to include("#{Time.zone.now.strftime('%Y%m%d')}_sales.csv")
        end
      end
    end

    describe '詳細表示機能' do
      let(:login_user) { user_a }

      context 'ユーザーAの詳細画面へアクセス' do
        it 'ユーザーAの情報が表示されていること' do
          visit user_sale_path(user_a, sale)
          expect(page).to have_selector 'td', text: sale.created_at.strftime('%Y/%m/%d %H:%M') 
          expect(page).to have_selector 'td', text: sale.maker.name
          expect(page).to have_selector 'td', text: sale.producttype.name
          expect(page).to have_selector 'td', text: "#{sale.amount_sold.to_s.chars.insert(2,',').join}円"
          expect(page).to have_selector 'td', text: sale.remark
          expect(page).to have_selector 'td', text: get_holiday(sale.created_at)
          expect(page).to have_selector 'td', text: get_weather(sale.weather.weather_id)
        end
      end
    end

    describe '新規登録機能' do
      let(:login_user) { user_a }
      
      before do
        visit new_user_sale_path(login_user)
      end

      context '売上情報を有効な値で登録した場合' do
        it '登録に成功する' do
          select 'テスト会社', from: 'sale[maker_id]'
          select 'カバン', from: 'sale[producttype_id]'
          fill_in 'sale[amount_sold]', with: 50000
          fill_in 'sale[remark]', with: 'セール価格'
          # DB上に登録されていること
          expect {
            click_button '登録'
          }.to change(Sale, :count).by(1)

          # 一覧画面へ遷移していること
          expect(page).to have_current_path user_sales_path(login_user)
          # 成功時のフラッシュが表示されていること
          expect(page).to have_selector 'div.alert.alert-success'
          # 一覧画面に、登録した売上情報が反映されていること
          expect(page).to have_content 'テスト会社'
          expect(page).to have_content 'カバン'
          expect(page).to have_content '50,000円'
          expect(page).to have_content 'セール価格'
        end
      end
      
      context '売上情報を無効な値で登録した場合' do
        it '登録に失敗する' do
          select '選択してください', from: 'sale[maker_id]'
          select '選択してください', from: 'sale[producttype_id]'
          fill_in 'sale[amount_sold]', with: 0
          # DB上に登録されていないこと
          expect {
            click_button '登録'
          }.to_not change(Sale, :count)
          # エラーメッセージが表示されていること
          expect(page).to have_selector '#error_explanation'
        end
      end
    end


    describe '編集機能' do
      let(:login_user) { user_a }
      let!(:maker) { FactoryBot.create(:maker, name: 'メーカーA', user: login_user) }
      let!(:producttype) { FactoryBot.create(:producttype, name:'商品A', user: login_user) }

      context '売上情報を有効な値で更新した場合' do
        it '更新に成功する' do
          visit edit_user_sale_path(login_user, sale)
          select 'メーカーA', from: 'sale[maker_id]'
          select '商品A', from: 'sale[producttype_id]'
          fill_in 'sale[amount_sold]', with: 20000
          fill_in 'sale[remark]', with: '３０％オフ'
          click_button '更新'

          # 正しい値に更新されているか
          sale.reload
          expect(sale.maker_id).to eq maker.id
          expect(sale.producttype_id).to eq producttype.id
          expect(sale.amount_sold).to eq 20000
          expect(sale.remark).to eq '３０％オフ'
          # 一覧画面へ遷移していること
          expect(page).to have_current_path user_sales_path(login_user)
          # 成功時のフラッシュが表示されていること
          expect(page).to have_selector 'div.alert.alert-success'
          # 更新したメーカーが表示されていること
          expect(page).to have_content 'メーカーA'
          expect(page).to have_content '商品A'
          expect(page).to have_content '20,000円'
          expect(page).to have_content '３０％オフ'
        end
      end
      
      context '売上情報を無効な値で更新した場合' do
        it '更新に失敗する' do
          sale_before = sale
          visit edit_user_sale_path(login_user, sale)
          select '選択してください', from: 'sale[maker_id]'
          select '選択してください', from: 'sale[producttype_id]'
          fill_in 'sale[amount_sold]', with: 0
          click_button '更新'
          sale.reload
          # 更新前と値が変わっていないこと
          expect(sale).to be sale_before
          # エラーメッセージが表示されること
          expect(page).to have_selector '#error_explanation'
        end
      end
    end


    describe '削除機能' do
      let(:login_user) { user_a }

      context '一覧画面で削除ボタンをクリックした場合' do
        it '削除に成功する' do
          visit user_sales_path(login_user)
          # DB上で削除されていること
          expect {
            page.all("a[href='/users/#{sale.user.id}/sales/#{sale.id}']")[1].click
          }.to change(Sale, :count).by(-1)
          # 一覧画面へ遷移していること
          expect(page).to have_current_path user_sales_path(login_user)
          # 削除した売上情報が表示されていないこと
          expect(page).to have_no_content 'テスト会社'
          expect(page).to have_no_content 'カバン'
        end
      end
    end
  end
end
