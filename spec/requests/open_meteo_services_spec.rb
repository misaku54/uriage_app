require 'rails_helper'

RSpec.describe "OpenMeteoServices", type: :request do
  describe "GET /open_meteo_services" do
    it "works! (now write some real specs)" do
      get open_meteo_services_path
      expect(response).to have_http_status(200)
    end
  end
end
