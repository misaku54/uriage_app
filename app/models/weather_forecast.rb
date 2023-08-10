class WeatherForecast < ApplicationRecord
  attribute :aquired_on, default: -> { Time.zone.now }
  has_many :sales, foreign_key: "created_on"
end
