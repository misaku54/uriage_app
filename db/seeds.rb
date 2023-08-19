# 管理者権限ユーザー作成
User.create!( name:     "admin User",
              email:    "admin@sample.com",
              admin:    true,
              password: "foobar",
              password_confirmation: "foobar")

# 受け入れテスト用ユーザー作成
User.create!( name:     "Test User",
              email:    "test@sample.com",
              admin:    false,
              password: "password",
              password_confirmation: "password")

# 追加のユーザーをまとめて生成する
20.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@sample.com"
  password = "password"
  User.create!(name:  name,
      email: email,
      password:              password,
      password_confirmation: password)
end

# ユーザー５人にそれぞれメーカー、商品分類、売上データを作成していく
users = User.order(:created_at).take(5)

# ユーザー一人に対して、メーカーと商品分類データを５件ずつ登録する。
5.times do |n|
  maker_name = Faker::Company.unique.name
  product_name = Faker::Hobby.unique.activity
  users.each do |user| 
    user.makers.create!(name: maker_name)
    user.producttypes.create!(name: product_name)
  end
end

# 参照整合性制約のため、先に天気情報を登録
1.upto(12) do |month|
  1.upto(15) do |day|
    # 2021年度分
    WeatherForecast.create!(aquired_on: Time.zone.local(2021, month, day),
                            weather_id: rand(0..99),
                            temp_max: rand(25.0..30.0).floor(1),
                            temp_min: rand(20.0..24.9).floor(1),
                            rainfall_sum: rand(0..10.0).floor(1))
    # 2022年度分
    WeatherForecast.create!(aquired_on: Time.zone.local(2022, month, day),
                            weather_id: rand(0..99),
                            temp_max: rand(25.0..30.0).floor(1),
                            temp_min: rand(20.0..24.9).floor(1),
                            rainfall_sum: rand(0..10.0).floor(1))
  end
end
WeatherForecast.create!(aquired_on: Time.zone.now,
weather_id: rand(0..99),
temp_max: rand(25.0..30.0).floor(1),
temp_min: rand(20.0..24.9).floor(1),
rainfall_sum: rand(0..10.0).floor(1))

# ユーザー一人に対して、２年度分で一ヶ月ごとに15日分の売上データを生成する。
users.each do |user|
  maker_ids   = user.makers.ids
  product_ids = user.producttypes.ids 
  sales = user.sales
  
  1.upto(12) do |month|
    1.upto(15) do |day|
      # 2021年度分
      sales.create!(maker_id: maker_ids.sample, 
                    producttype_id: product_ids.sample,
                    user_id: user.id,
                    amount_sold: rand(1..9) * 1000,
                    created_at: Time.zone.local(2021, month, day))
      # 2022年度分
      sales.create!(maker_id: maker_ids.sample, 
                    producttype_id: product_ids.sample,
                    user_id: user.id,
                    amount_sold: rand(1..9) * 1000,
                    created_at: Time.zone.local(2022, month, day))
    end
  end
end