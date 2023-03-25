require 'rails_helper'

RSpec.xdescribe "Makers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/makers/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/makers/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/makers/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
