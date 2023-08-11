class WeatherForecast < ApplicationRecord
  # :aquired_onのデフォルト値に現在の日付を設定 
  # attribute :aquired_on, default: -> { Time.zone.now }
  
  # 関連付け
  has_many :sales, foreign_key: "created_on"

  # バリデーション
  validates :aquired_on, presence: true
  validates :weather_id, presence: true, numericality: true
  validates :temp_max, presence: true, numericality: true
  validates :temp_min, presence: true, numericality: true
  validates :rainfall_sum, presence: true, numericality: true
end
