FactoryBot.define do
  factory :sale do
    amount_sold { 10000 }
    remark { '期間限定商品' }
    created_at { Time.current }
    association :user
    maker { FactoryBot.create(:maker, user: user) }
    producttype { FactoryBot.create(:producttype,user: user) } 
  end

  # 年次集計用
  factory :yearly_aggregate_sale, class: Sale do
    sequence(:amount_sold) { 1000 }
    sequence(:remark) { |n| "Test yearly_aggregate #{n}" }
    # 2022年の1月〜12月の売り上げデータを月毎に１件ずつ生成
    sequence(:created_at) { |n| Time.local(2023, 1, 1).prev_month(n) } 
    user 
    maker
    producttype
  end 

  # 月次集計用
  factory :monthly_aggregate_sale, class: Sale do
    sequence(:amount_sold) { 1000 }
    sequence(:remark) { |n| "Test daily_aggregate #{n}" }
    sequence(:created_at) { |n| Time.local(2023, 1, 1).prev_day(n)  } 
    user 
    maker
    producttype
  end 
end
