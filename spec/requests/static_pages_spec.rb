require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET root" do
    it "レスポンスが正常であること" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
