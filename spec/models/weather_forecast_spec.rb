require 'rails_helper'

RSpec.describe WeatherForecast, type: :model do
  describe 'バリデーション' do
    let!(:weather) { FactoryBot.build(:weather) }
    it 'weatherが有効であること' do
      expect(weather).to be_valid
    end

    it 'aquired_onがなければ無効になること' do
      weather.aquired_on = nil
      expect(weather).to_not be_valid
    end

    it 'weather_idがなければ無効になること' do
      weather.weather_id = nil
      expect(weather).to_not be_valid
    end

    it 'temp_maxがなければ無効になること' do
      weather.temp_max = nil
      expect(weather).to_not be_valid
    end

    it 'temp_minがなければ無効になること' do
      weather.temp_min = nil
      expect(weather).to_not be_valid
    end

    it 'rainfall_sumがなければ無効になること' do
      weather.rainfall_sum = nil
      expect(weather).to_not be_valid
    end
  end
end
