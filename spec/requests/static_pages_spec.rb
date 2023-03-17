require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:base_title) { 'せるまね' }
  describe "#home" do
    before do
      get root_path
    end
    
    it "レスポンスが正常であること" do
      expect(response).to have_http_status(:success)
    end
    
    it "タイトルが正常に表示されていること" do
      expect(response.body).to include("#{base_title}")
    end
  end
end
