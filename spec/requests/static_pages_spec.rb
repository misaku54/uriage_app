require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe "#home" do
    context '未ログイン' do
      before do
        get root_path
      end

      it "レスポンスが正常であること" do
        expect(response).to have_http_status(:success)
      end

      it "タイトルが正常に表示されていること" do
        expect(response.body).to include('LiLy')
      end

      it 'ログイン時にしか出ない項目が表示されていないこと' do
        expect(response.body).to_not include('日付')
        expect(response.body).to_not include('天気情報')
        expect(response.body).to_not include('本日の売上')
      end
    end

    context 'ログイン中' do
      before do
        log_in(user)
      end

      context '当日の売上データがある場合' do
        let!(:weather) { FactoryBot.create(:weather) }
        let!(:sale) { FactoryBot.create(:sale, user: user) }

        before do
          get root_path
          @sales_trend = controller.instance_variable_get(:@sales_trend)
          @sales_total_amount = controller.instance_variable_get(:@sales_total_amount)
        end

        it '売上推移と売上合計額が取得されていること' do
          expect(@sales_trend).to be_present
          expect(@sales_total_amount).to be_present
        end

        it 'レスポンスが正常であること' do
          expect(response).to have_http_status(:success)
        end

        it 'タイトルが正常に表示されていること' do
          expect(response.body).to include('LiLy')
        end

        it 'ログイン時にしか出ない項目が表示されていること' do
          expect(response.body).to include('日付')
          expect(response.body).to include('天気情報')
          expect(response.body).to include('本日の売上')
        end
      end

      context '当日の売上データがない場合' do
        before do
          get root_path
        end

        it '売上推移と売上合計額が取得されていないこと' do
          expect(@sales_trend).to_not be_present
          expect(@sales_total_amount).to_not be_present
        end

        it 'レスポンスが正常であること' do
          expect(response).to have_http_status(:success)
        end

        it 'タイトルが正常に表示されていること' do
          expect(response.body).to include('LiLy')
        end

        it 'ログイン時にしか出ない項目が表示されていること' do
          expect(response.body).to include('日付')
          expect(response.body).to include('天気情報')
          expect(response.body).to include('本日の売上')
        end
      end
    end
  end
end
