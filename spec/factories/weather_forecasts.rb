FactoryBot.define do
  factory :weather, class: WeatherForecast do
    aquired_on { Time.zone.now }
    weather_id { rand(0..99) }
    temp_max { rand(25.0..30.0).floor(1) }
    temp_min { rand(20.0..24.9).floor(1) }
    rainfall_sum { rand(0..10.0).floor(1) }

    # 年別集計のテストで使用するデータを用意
    trait :yearly_this_year do 
      sequence(:aquired_on) { |n| Time.zone.local(2021, 12, 1).next_month(n) }
    end
    trait :yearly_last_year do
      sequence(:aquired_on) { |n| Time.zone.local(2020, 12, 1).next_month(n) }
    end

    # 月別集計のテストで使用するデータを用意
    trait :monthly_this_year do
      sequence(:aquired_on) { |n| Time.zone.local(2021, 12, 31).next_day(n) }
    end
    trait :monthly_last_year do
      sequence(:aquired_on) { |n| Time.zone.local(2020, 12, 31).next_day(n) }
    end

    # 日別集計のテストで使用するデータを用意
    trait :daily_this_year do
      sequence(:aquired_on) { |n| Time.zone.local(2021, 12, 31).next_day(n) }
    end
    trait :daily_last_year do
      sequence(:aquired_on) { |n| Time.zone.local(2020, 12, 31).next_day(n) }
    end
  end
end
