require 'rails_helper'

RSpec.describe "Aggregates", type: :request do
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

    describe "#monthly_search" do
      let(:login_user) { user_a }
      let!(:monthly_aggregate_sale_a) {FactoryBot.reload; FactoryBot.create_list(:monthly_aggregate_sale, 30, user: user_a, maker: maker_a, producttype: producttype_a)}

      subject { get user_monthly_search_path(login_user), params: params; response } 

      context "パラメータのバリデーションが" do
        context "成功した場合" do
          let(:params) { { search_form: { date: "2022-1-1" } } }

          context "売上データがある場合" do
            it "集計した値がインスタンス変数に入ること" do
              is_expected.to render_template("monthly_aggregate") 
              expect(response).to have_http_status(:success)

              # コントローラーよりインスタンス変数を取得
              @aggregates_of_maker_producttype = controller.instance_variable_get('@aggregates_of_maker_producttype')
              @aggregates_of_maker             = controller.instance_variable_get('@aggregates_of_maker')
              @aggregates_of_producttype       = controller.instance_variable_get('@aggregates_of_producttype')
              @sales_trend                     = controller.instance_variable_get('@sales_trend')
              @sales_total_amount              = controller.instance_variable_get('@sales_total_amount')
              @sales_growth_rate               = controller.instance_variable_get('@sales_growth_rate')
              # インスタンス変数に値がセットされているか
              expect(@aggregates_of_maker_producttype).to be_present
              expect(@aggregates_of_maker).to be_present
              expect(@aggregates_of_producttype).to be_present
              expect(@sales_trend).to be_present
              expect(@sales_total_amount).to be_present
              expect(@sales_growth_rate).to be_present
            end
          end
          context "売上データがない場合" do
            let(:params) { { search_form: { date: "2022-11-1" } } }
            
            it "集計期間に該当する売上データがない旨のメッセージが返ってくること" do
              is_expected.to render_template("monthly_aggregate") 
              expect(response).to have_http_status(:success)

              # コントローラーよりインスタンス変数を取得
              @no_result = controller.instance_variable_get('@no_result')
              # インスタンス変数にメッセージがセットされているか
              expect(@no_result).to eq '集計期間に該当する売上データがありません。'
            end
          end
        end

        context "失敗した場合" do
          it "インスタンス変数に値が入らないこと" do

          end
        end
      end
    end
  end
end
