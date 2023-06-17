require 'rails_helper'

RSpec.describe "Aggregates", type: :request do
  let!(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 
  let!(:producttype_a) { FactoryBot.create(:producttype, name:'商品A', user: user_a) }
  let!(:maker_a) { FactoryBot.create(:maker, name:'メーカーA', user: user_a) }

  describe 'ログイン中' do
    before do
      log_in(login_user)
    end

    describe "#monthly_search" do
      let(:login_user) { user_a }
      # FactoryBot.reload
      # let!(:monthly_aggregate_sale) {FactoryBot.create_list(:monthly_aggregate_sale, 30, user: user_a, maker: maker_a, producttype: producttype_a)}
      # before do
      #   get user_monthly_search_path(login_user), params: { search_form: { date: "2022-01-12" } }
      # end

      subject { get user_monthly_search_path(login_user), params: params; response } 

      context "パラメータのバリデーションが" do
        context "成功した場合" do
          let(:params) { { search_form: { date: "2022-01-12" } } }

          context "売上データがある場合" do
            it "集計した値がインスタンス変数に入ること" do
              is_expected.to have_http_status(:success)
              is_expected.to render_template("monthly_aggregate") 
              @aggregates_of_maker_producttype = controller.instance_variable_get('@aggregates_of_maker_producttype')
            end
          end
          context "売上データがない場合" do
            it "集計期間に該当する売上データがない旨のメッセージが返ってくること" do

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
