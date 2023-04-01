require 'rails_helper'

RSpec.describe "Sales", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/sales/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/sales/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/sales/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
