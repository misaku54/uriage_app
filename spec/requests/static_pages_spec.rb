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
        get root_path
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
