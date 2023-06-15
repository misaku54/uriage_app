require 'rails_helper'

RSpec.describe "集計機能", type: :system do
  let!(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 
  let!(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') } 

  let!(:producttype_a) { FactoryBot.create(:producttype, name:'商品A', user: user_a) }
  let!(:producttype_b) { FactoryBot.create(:producttype, name:'商品B', user: user_a) }
  let!(:producttype_c) { FactoryBot.create(:producttype, name:'商品C', user: user_a) }
  let!(:maker_a) { FactoryBot.create(:maker, name:'メーカーA', user: user_a) }
  let!(:maker_b) { FactoryBot.create(:maker, name:'メーカーB', user: user_a) }
  let!(:maker_c) { FactoryBot.create(:maker, name:'メーカーC', user: user_a) }


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
      let!(:yearly_aggregate_sale) {FactoryBot.create_list(:yearly_aggregate_sale, 12, user: user_a, maker: maker_a, producttype: producttype_a)}

      before do
        visit user_yearly_aggregate_path(login_user)
      end

      context '2022年で集計ボタンを押下した場合' do
        it '集計結果が表示されること' do
          select '2022', from: 'search_form[date(1i)]'
          click_button '集計'
          expect(page).to have_content '合計純売上'
          expect(page).to have_content '売上推移'
          expect(page).to have_content '売上ランキング（メーカー、商品分類別）'
          expect(page).to have_content '売上ランキング（メーカー別）'
          expect(page).to have_content '売上ランキング（商品分類別）'
          expect(page).to have_content '集計結果（メーカー、商品分類別の販売額の合計）'
          expect(page).to have_content '集計結果（メーカー別の販売額の合計）'
          expect(page).to have_content '集計結果（商品分類別の販売額の合計）'
        end
      end 

      context 'データのない年度で集計ボタンを押下した場合' do
        it '集計結果が表示されないこと' do
          # ２週目の時にでsequencenの値が継続しているため、2021年のデータが作成されてしまう。そのため、テスト対象の年度を2020とした。
          select '2020', from: 'search_form[date(1i)]'
          click_button '集計'
          expect(page).to have_no_content '合計純売上'
          expect(page).to have_no_content '売上推移'
          expect(page).to have_no_content '売上ランキング（メーカー、商品分類別）'
          expect(page).to have_no_content '売上ランキング（メーカー別）'
          expect(page).to have_no_content '売上ランキング（商品分類別）'
          expect(page).to have_no_content '集計結果（メーカー、商品分類別の販売額の合計）'
          expect(page).to have_no_content '集計結果（メーカー別の販売額の合計）'
          expect(page).to have_no_content '集計結果（商品分類別の販売額の合計）'
        end
      end
    end
    
    describe '月次集計機能' do
      let(:login_user) { user_a }
      let!(:monthly_aggregate_sale) {FactoryBot.create_list(:monthly_aggregate_sale, 30, user: user_a, maker: maker_a, producttype: producttype_a)}

      before do
        visit user_monthly_aggregate_path(login_user)
      end

      context '2022年12月で集計ボタンを押下した場合' do
        it '集計結果が表示されること' do
          select '2022', from: 'search_form[date(1i)]'
          select '12', from: 'search_form[date(2i)]'
          click_button '集計する'
          expect(page).to have_content '合計純売上'
          expect(page).to have_content '売上推移'
          expect(page).to have_content '売上ランキング（メーカー、商品分類別）'
          expect(page).to have_content '売上ランキング（メーカー別）'
          expect(page).to have_content '売上ランキング（商品分類別）'
          expect(page).to have_content '集計結果（メーカー、商品分類別の販売額の合計）'
          expect(page).to have_content '集計結果（メーカー別の販売額の合計）'
          expect(page).to have_content '集計結果（商品分類別の販売額の合計）'
        end
      end

      context 'データのない年月で集計ボタンを押下した場合' do
        it '集計結果が表示されないこと' do
          select '2022', from: 'search_form[date(1i)]'
          select '9', from: 'search_form[date(2i)]'
          click_button '集計する'
          expect(page).to have_no_content '合計純売上'
          expect(page).to have_no_content '売上推移'
          expect(page).to have_no_content '売上ランキング（メーカー、商品分類別）'
          expect(page).to have_no_content '売上ランキング（メーカー別）'
          expect(page).to have_no_content '売上ランキング（商品分類別）'
          expect(page).to have_no_content '集計結果（メーカー、商品分類別の販売額の合計）'
          expect(page).to have_no_content '集計結果（メーカー別の販売額の合計）'
          expect(page).to have_no_content '集計結果（商品分類別の販売額の合計）'
        end
      end
    end

    describe '日次集計機能' do
      let(:login_user) { user_a }
      let!(:daily_aggregate_sale) {FactoryBot.create_list(:daily_aggregate_sale, 15, user: user_a, maker: maker_a, producttype: producttype_a)}

      before do
        visit user_daily_aggregate_path(login_user)
      end

      context '2022年12月で集計ボタンを押下した場合' do
        it '集計結果が表示されること' do
          fill_in 'search_daily[start_date]' , with: '002022-12-01'
          fill_in 'search_daily[end_date]' , with: '002022-12-31'
          click_button '集計する'
          expect(page).to have_content '合計純売上'
          expect(page).to have_content '売上推移'
          expect(page).to have_content '売上ランキング（メーカー、商品分類別）'
          expect(page).to have_content '売上ランキング（メーカー別）'
          expect(page).to have_content '売上ランキング（商品分類別）'
          expect(page).to have_content '集計結果（メーカー、商品分類別の販売額の合計）'
          expect(page).to have_content '集計結果（メーカー別の販売額の合計）'
          expect(page).to have_content '集計結果（商品分類別の販売額の合計）'
        end
      end

      context 'データのない年月で集計ボタンを押下した場合' do
        it '集計結果が表示されないこと' do
          fill_in 'search_daily[start_date]' , with: '002022-10-01'
          fill_in 'search_daily[end_date]' , with: '002022-10-31'
          click_button '集計する'
          expect(page).to have_no_content '合計純売上'
          expect(page).to have_no_content '売上推移'
          expect(page).to have_no_content '売上ランキング（メーカー、商品分類別）'
          expect(page).to have_no_content '売上ランキング（メーカー別）'
          expect(page).to have_no_content '売上ランキング（商品分類別）'
          expect(page).to have_no_content '集計結果（メーカー、商品分類別の販売額の合計）'
          expect(page).to have_no_content '集計結果（メーカー別の販売額の合計）'
          expect(page).to have_no_content '集計結果（商品分類別の販売額の合計）'
        end
      end
    end
  end
end