require 'rails_helper'

RSpec.describe "Aggregates", type: :request do
  let!(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') } 

  describe 'ログイン中' do
    before do
      log_in(login_user)
    end

    describe "#monthly_search" do
      let(:login_user) { user_a }
      
      before do
        get user_monthly_search_path(login_user), params: { search_form: { date: "2022-01-12" } }
      end

      context "パラメータのバリデーションが" do
        context "成功した場合" do
          context "売上データがある場合" do
            it "集計した値がインスタンス変数に入ること" do

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
