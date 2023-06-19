require 'rails_helper'

RSpec.describe 'Aggregates', type: :request do
  let!(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 
  let!(:producttype_a) { FactoryBot.create(:producttype, name:'商品A', user: user_a) }
  let!(:producttype_b) { FactoryBot.create(:producttype, name:'商品B', user: user_a) }
  let!(:producttype_c) { FactoryBot.create(:producttype, name:'商品C', user: user_a) }
  let!(:maker_a) { FactoryBot.create(:maker, name:'メーカーA', user: user_a) }
  let!(:maker_b) { FactoryBot.create(:maker, name:'メーカーB', user: user_a) }
  let!(:maker_c) { FactoryBot.create(:maker, name:'メーカーC', user: user_a) }

  describe 'ログイン中' do
    before do
      log_in(login_user)
    end

    describe '#monthly_search' do
      let(:login_user) { user_a }
      # 2022年1月の登録日時で、メーカAと商品Aの組み合わせの売上データを３０件、メーカBと商品Bの組み合わせの売上データを２０件、メーカCと商品Cの組み合わせの売上データを１０件作成する。
      let!(:monthly_aggregate_sale_a) {FactoryBot.reload; FactoryBot.create_list(:monthly_aggregate_sale, 30, user: user_a, maker: maker_a, producttype: producttype_a)}
      let!(:monthly_aggregate_sale_b) {FactoryBot.reload; FactoryBot.create_list(:monthly_aggregate_sale, 20, user: user_a, maker: maker_b, producttype: producttype_b)}
      let!(:monthly_aggregate_sale_c) {FactoryBot.reload; FactoryBot.create_list(:monthly_aggregate_sale, 10, user: user_a, maker: maker_c, producttype: producttype_c)}
      # 2021年1月の登録日時で、メーカAと商品Aの組み合わせの売上データを３０件、メーカBと商品Bの組み合わせの売上データを２０件、メーカCと商品Cの組み合わせの売上データを１０件作成する。
      let!(:last_year_monthly_aggregate_sale_a) {FactoryBot.reload; FactoryBot.create_list(:monthly_aggregate_sale, 30, :last_year, user: user_a, maker: maker_a, producttype: producttype_a)}
      let!(:last_year_monthly_aggregate_sale_b) {FactoryBot.reload; FactoryBot.create_list(:monthly_aggregate_sale, 20, :last_year, user: user_a, maker: maker_b, producttype: producttype_b)}
      let!(:last_year_monthly_aggregate_sale_c) {FactoryBot.reload; FactoryBot.create_list(:monthly_aggregate_sale, 10, :last_year, user: user_a, maker: maker_c, producttype: producttype_c)}

      subject { get user_monthly_search_path(login_user), params: params; response } 

      context 'パラメータのバリデーションが' do
        context '成功した場合' do
          let(:params) { { search_form: { date: '2022-1-1' } } }

          context '売上データがある場合' do
            before do
              subject
              # コントローラーよりインスタンス変数を取得
              @aggregates_of_maker_producttype = controller.instance_variable_get('@aggregates_of_maker_producttype')
              @aggregates_of_maker             = controller.instance_variable_get('@aggregates_of_maker')
              @aggregates_of_producttype       = controller.instance_variable_get('@aggregates_of_producttype')
              @sales_trend                     = controller.instance_variable_get('@sales_trend')
              @sales_total_amount              = controller.instance_variable_get('@sales_total_amount')
              @sales_growth_rate               = controller.instance_variable_get('@sales_growth_rate')            
            end

            it 'レスポンスが正常であること' do
              expect(response).to have_http_status(:success)
            end

            it '意図した画面に遷移すること' do
              expect(response).to render_template('monthly_aggregate')
            end

            it "集計した値がインスタンス変数に入ること" do
              expect(@aggregates_of_maker_producttype).to be_present
              expect(@aggregates_of_maker).to be_present
              expect(@aggregates_of_producttype).to be_present
              expect(@sales_trend).to be_present
              expect(@sales_total_amount).to be_present
              expect(@sales_growth_rate).to be_present
            end

            it 'インスタンス変数の中身の整合性チェック(@aggregates_of_maker_producttype)' do
              aggregates_of_maker_producttype_1st = @aggregates_of_maker_producttype.first 
              aggregates_of_maker_producttype_2nd = @aggregates_of_maker_producttype.second 
              aggregates_of_maker_producttype_3rd = @aggregates_of_maker_producttype.third 
              # １位、２位、３位のインスタンスにセットされているメーカー名が正しい値か
              expect(aggregates_of_maker_producttype_1st.maker_name).to eq 'メーカーA'
              expect(aggregates_of_maker_producttype_2nd.maker_name).to eq 'メーカーB'
              expect(aggregates_of_maker_producttype_3rd.maker_name).to eq 'メーカーC'
              # １位、２位、３位のインスタンスにセットされている商品分類名が正しい値か
              expect(aggregates_of_maker_producttype_1st.producttype_name).to eq '商品A'
              expect(aggregates_of_maker_producttype_2nd.producttype_name).to eq '商品B'
              expect(aggregates_of_maker_producttype_3rd.producttype_name).to eq '商品C'
              # １位、２位、３位のインスタンスにセットされている合計売上額が正しい値か
              expect(aggregates_of_maker_producttype_1st.sum_amount_sold).to eq 30000
              expect(aggregates_of_maker_producttype_2nd.sum_amount_sold).to eq 20000
              expect(aggregates_of_maker_producttype_3rd.sum_amount_sold).to eq 10000
              # １位、２位、３位のインスタンスにセットされている合計販売数量が正しい値か
              expect(aggregates_of_maker_producttype_1st.quantity_sold).to eq 30
              expect(aggregates_of_maker_producttype_2nd.quantity_sold).to eq 20
              expect(aggregates_of_maker_producttype_3rd.quantity_sold).to eq 10
              # １位、２位、３位のインスタンスにセットされている去年の合計売上額が正しい値か
              expect(aggregates_of_maker_producttype_1st.last_year_sum_amount_sold).to eq 15000
              expect(aggregates_of_maker_producttype_2nd.last_year_sum_amount_sold).to eq 10000
              expect(aggregates_of_maker_producttype_3rd.last_year_sum_amount_sold).to eq 5000
              # １位、２位、３位のインスタンスにセットされている去年の合計販売数量が正しい値か
              expect(aggregates_of_maker_producttype_1st.last_year_quantity_sold).to eq 30
              expect(aggregates_of_maker_producttype_2nd.last_year_quantity_sold).to eq 20
              expect(aggregates_of_maker_producttype_3rd.last_year_quantity_sold).to eq 10
              # １位、２位、３位のインスタンスにセットされている売上成長率が正しい値か
              expect(aggregates_of_maker_producttype_1st.sales_growth_rate).to eq "100.0%"
              expect(aggregates_of_maker_producttype_2nd.sales_growth_rate).to eq "100.0%"
              expect(aggregates_of_maker_producttype_3rd.sales_growth_rate).to eq "100.0%"
            end
          end

          context '売上データがない場合' do
            let(:params) { { search_form: { date: '2022-11-1' } } }
            
            before do
              subject
              # コントローラーよりインスタンス変数を取得
              @no_result = controller.instance_variable_get('@no_result')
            end

            it 'レスポンスが正常であること' do
              expect(response).to have_http_status(:success)
            end

            it '意図した画面に遷移すること' do
              expect(response).to render_template('monthly_aggregate')
            end

            it '集計期間に該当する売上データがない旨のメッセージが返ってくること' do
              expect(@no_result).to eq '集計期間に該当する売上データがありません。'
            end
          end
        end

        context '失敗した場合' do
          it 'インスタンス変数に値が入らないこと' do

          end
        end
      end
    end
  end
end
