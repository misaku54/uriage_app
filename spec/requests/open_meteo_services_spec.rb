require 'rails_helper'

RSpec.describe "OpenMeteoService", type: :request do
  describe 'API' do
    let(:today) { Time.zone.today }
    it "APIレスポンスが正しく取得できること" do
      api = OpenMeteoService.new
      result = api.get_weather_info(today)
      expect(api).to be_an_instance_of(OpenMeteoService)
      expect(result[:hourly]).to include(:temperature_2m)
      expect(result[:hourly]).to include(:weathercode)
      expect(result[:hourly]).to include(:precipitation_probability)
      expect(result[:daily]).to include(:weathercode)
      expect(result[:daily]).to include(:temperature_2m_max)
      expect(result[:daily]).to include(:temperature_2m_min)
      expect(result[:daily]).to include(:precipitation_sum)
      expect(result[:daily]).to include(:time)
    end
  end
end
