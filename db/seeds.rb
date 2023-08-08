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

users = User.order(:created_at).take(5)
# ユーザー一人につき
5.times do |n|
  maker_name = Faker::Company.name
  product_name = Faker::Coin.name
  users.each do |user| 
    user.makers.create!(name: maker_name)
    user.producttypes.create!(name: product_name)
  end
end

users.each do |user|
  maker_ids   = user.makers.ids
  product_ids = user.producttypes.ids 
  sales = user.sales
  1.upto(12) do |month|
    1.upto(15) do |day|
      sales.create!(maker_id: maker_ids.sample, 
                    producttype_id: product_ids.sample,
                    user_id: user.id,
                    amount_sold: rand(1..9) * 1000,
                    created_at: Time.zone.local(2022, month, day))
    end
  end
end


# 商品分類5件登録
# 売上情報60件登録（２年分で120件）1ヶ月で５件ずつ登録
# 一ヶ月ごとに５件ずつ登録

# users = User.order(:created_at).take(5)
# 50.times do
#   maker_name = Faker::Company.name(word_count: 5)
#   users.each { |user| user.makers.create!(name: maker_name) }
# end