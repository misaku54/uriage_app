# メインのサンプルユーザーを1人作成する
User.create!( name:     "Example User",
              email:    "example@railstutorial.org",
              admin:    true,
              password: "foobar",
              password_confirmation: "foobar")

# 追加のユーザーをまとめて生成する
19.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@sample.org"
password = "password"
User.create!(name:  name,
    email: email,
    password:              password,
    password_confirmation: password)
end
# users = User.order(:created_at).take(5)
# 50.times do
#   maker_name = Faker::Company.name(word_count: 5)
#   users.each { |user| user.makers.create!(name: maker_name) }
# end