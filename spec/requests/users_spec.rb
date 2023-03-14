require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "レスポンスが正常であること" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

end
