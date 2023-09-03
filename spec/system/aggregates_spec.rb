require 'rails_helper'

RSpec.describe "集計機能", type: :system do
  let!(:weather) { FactoryBot.create(:weather) }
  let!(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 
  let!(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') } 
  let!(:producttype_a) { FactoryBot.create(:producttype, name:'商品A', user: user_a) }
  let!(:maker_a) { FactoryBot.create(:maker, name:'メーカーA', user: user_a) }

  describe '未ログイン' do
    describe 'ページ遷移確認' do
      context '年次集計画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit user_yearly_aggregate_path(user_a)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context '月次集計画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit user_monthly_aggregate_path(user_a)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context '日次集計画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit user_daily_aggregate_path(user_a)
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

        context 'ユーザーAに紐づく年次集計画面へアクセス' do
          it '正常に遷移すること' do
            visit user_yearly_aggregate_path(login_user)
            expect(page).to have_current_path user_yearly_aggregate_path(login_user)
          end
        end

        context 'ユーザーAに紐づく月次集計画面へアクセス' do
          it '正常に遷移すること' do
            visit user_monthly_aggregate_path(login_user)
            expect(page).to have_current_path user_monthly_aggregate_path(login_user)
          end
        end
        
        context 'ユーザーAに紐づく日次集計画面へアクセス' do
          it '正常に遷移すること' do
            visit user_daily_aggregate_path(login_user)
            expect(page).to have_current_path user_daily_aggregate_path(login_user)
          end
        end
      end

      context 'ユーザーBでログインしている場合' do
        let(:login_user) { user_b }
        
        context 'ユーザーAに紐づく年次集計画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit user_yearly_aggregate_path(user_a)
            expect(page).to have_current_path root_path
          end
        end

        context 'ユーザーAに紐づく月次集計画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit user_monthly_aggregate_path(user_a)
            expect(page).to have_current_path root_path
          end
        end
        
        context 'ユーザーAに紐づく日次集計画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit user_daily_aggregate_path(user_a)
            expect(page).to have_current_path root_path
          end
        end
      end
    end
    
    describe '年次集計機能' do
      let(:login_user) { user_a }
      let!(:weather) {FactoryBot.reload; FactoryBot.create_list(:weather, 12, :yearly_this_year)}
      let!(:yearly_aggregate_sale) {FactoryBot.reload; FactoryBot.create_list(:aggregate_sale, 12, :yearly_this_year, user: user_a, maker: maker_a, producttype: producttype_a)}
      

      before do
        visit user_yearly_aggregate_path(login_user)
      end

      context 'データのある年度で集計ボタンを押下した場合' do
        it '集計結果が表示されること' do
          select '2022', from: 'search_form[date(1i)]'
          click_button '集計'
          expect(page).to have_content '合計純売上'
          expect(page).to have_content '最も売れたメーカー×商品分類'
          expect(page).to have_content '最も売れたメーカー'
          expect(page).to have_content '最も売れた商品分類'
          expect(page).to have_content '売上推移'
          expect(page).to have_content 'カテゴリ別の売上集計（グラフ）'
          expect(page).to have_content 'カテゴリ別の売上集計（一覧）'
        end
      end 

      context 'データのある年度でCSV出力ボタンを押下した場合' do
        it '正しい名前でCSVが出力されていること' do
          select '2022', from: 'search_form[date(1i)]'
          click_button 'CSV出力'
          expect(page.response_headers["Content-Type"]).to include "text/csv"
          expect(page.response_headers['Content-Disposition']).to include("#{Time.zone.now.strftime('%Y%m%d')}_shukei.csv")
        end
      end

      context 'データのない年度で集計ボタンを押下した場合' do
        it '集計結果が表示されないこと' do
          select '2021', from: 'search_form[date(1i)]'
          click_button '集計'
          expect(page).to have_no_content '合計純売上'
          expect(page).to have_no_content '最も売れたメーカー×商品分類'
          expect(page).to have_no_content '最も売れたメーカー'
          expect(page).to have_no_content '最も売れた商品分類'
          expect(page).to have_no_content '売上推移'
          expect(page).to have_no_content 'カテゴリ別の売上集計（グラフ）'
          expect(page).to have_no_content 'カテゴリ別の売上集計（一覧）'
          expect(page).to have_content '集計期間に該当する売上データがありません。'
        end
      end
    end
    
    describe '月次集計機能' do
      let(:login_user) { user_a }
      let!(:weather) {FactoryBot.reload; FactoryBot.create_list(:weather, 30, :monthly_this_year)}
      let!(:monthly_aggregate_sale) {FactoryBot.reload; FactoryBot.create_list(:aggregate_sale, 30, :monthly_this_year, user: user_a, maker: maker_a, producttype: producttype_a)}

      before do
        visit user_monthly_aggregate_path(login_user)
      end

      context 'データのある年月で集計ボタンを押下した場合' do
        it '集計結果が表示されること' do
          select '2022', from: 'search_form[date(1i)]'
          select '1', from: 'search_form[date(2i)]'
          click_button '集計'
          expect(page).to have_content '合計純売上'
          expect(page).to have_content '最も売れたメーカー×商品分類'
          expect(page).to have_content '最も売れたメーカー'
          expect(page).to have_content '最も売れた商品分類'
          expect(page).to have_content '売上推移'
          expect(page).to have_content 'カテゴリ別の売上集計（グラフ）'
          expect(page).to have_content 'カテゴリ別の売上集計（一覧）'
        end
      end

      context 'データのある年月でCSV出力ボタンを押下した場合' do
        it '正しい名前でCSVが出力されていること' do
          select '2022', from: 'search_form[date(1i)]'
          select '1', from: 'search_form[date(2i)]'
          click_button 'CSV出力'
          expect(page.response_headers["Content-Type"]).to include "text/csv"
          expect(page.response_headers['Content-Disposition']).to include("#{Time.zone.now.strftime('%Y%m%d')}_shukei.csv")
        end
      end

      context 'データのない年月で集計ボタンを押下した場合' do
        it '集計結果が表示されないこと' do
          select '2022', from: 'search_form[date(1i)]'
          select '2', from: 'search_form[date(2i)]'
          click_button '集計'
          expect(page).to have_no_content '合計純売上'
          expect(page).to have_no_content '最も売れたメーカー×商品分類'
          expect(page).to have_no_content '最も売れたメーカー'
          expect(page).to have_no_content '最も売れた商品分類'
          expect(page).to have_no_content '売上推移'
          expect(page).to have_no_content 'カテゴリ別の売上集計（グラフ）'
          expect(page).to have_no_content 'カテゴリ別の売上集計（一覧）'
          expect(page).to have_content '集計期間に該当する売上データがありません。'
        end
      end
    end

    describe '日次集計機能' do
      let(:login_user) { user_a }
      let!(:weather) {FactoryBot.reload; FactoryBot.create_list(:weather, 35, :daily_this_year)}
      let!(:daily_aggregate_sale) {FactoryBot.reload; FactoryBot.create_list(:aggregate_sale, 15, :daily_this_year, user: user_a, maker: maker_a, producttype: producttype_a)}

      before do
        visit user_daily_aggregate_path(login_user)
      end

      context 'データのある期間で集計ボタンを押下した場合' do
        it '集計結果が表示されること' do
          fill_in 'search_daily[start_date]' , with: '2022-01-01'
          fill_in 'search_daily[end_date]' , with: '2022-01-31'
          click_button '集計'
          expect(page).to have_content '合計純売上'
          expect(page).to have_content '最も売れたメーカー×商品分類'
          expect(page).to have_content '最も売れたメーカー'
          expect(page).to have_content '最も売れた商品分類'
          expect(page).to have_content '売上推移'
          expect(page).to have_content 'カテゴリ別の売上集計（グラフ）'
          expect(page).to have_content 'カテゴリ別の売上集計（一覧）'
        end
      end

      context 'データのある期間でCSV出力ボタンを押下した場合' do
        it '正しい名前でCSVが出力されていること' do
          fill_in 'search_daily[start_date]' , with: '2022-01-01'
          fill_in 'search_daily[end_date]' , with: '2022-01-31'
          click_button 'CSV出力'
          expect(page.response_headers["Content-Type"]).to include "text/csv"
          expect(page.response_headers['Content-Disposition']).to include("#{Time.zone.now.strftime('%Y%m%d')}_shukei.csv")
        end
      end

      context 'データのない期間で集計ボタンを押下した場合' do
        it '集計結果が表示されないこと' do
          fill_in 'search_daily[start_date]' , with: '2022-02-01'
          fill_in 'search_daily[end_date]' , with: '2022-02-28'
          click_button '集計'
          expect(page).to have_no_content '合計純売上'
          expect(page).to have_no_content '最も売れたメーカー×商品分類'
          expect(page).to have_no_content '最も売れたメーカー'
          expect(page).to have_no_content '最も売れた商品分類'
          expect(page).to have_no_content '売上推移'
          expect(page).to have_no_content 'カテゴリ別の売上集計（グラフ）'
          expect(page).to have_no_content 'カテゴリ別の売上集計（一覧）'
          expect(page).to have_content '集計期間に該当する売上データがありません。'
        end
      end
    end
  end
end