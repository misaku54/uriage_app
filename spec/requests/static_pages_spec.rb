require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:base_title) { 'せるまね' }
  describe "GET root" do
    it "レスポンスが正常であること" do
      get root_path
      expect(response).to have_http_status(:success)
    end
    it "タイトルが正常に表示されていること" do
      get root_path
      expect(response.body).to include("#{base_title}")
    end
  end
end
