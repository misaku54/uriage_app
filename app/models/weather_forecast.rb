class WeatherForecast < ApplicationRecord
  attribute :aquired_on, default: -> { Time.zone.now }
end
