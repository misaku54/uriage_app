FactoryBot.define do
  factory :sale do
    amount_sold { 10000 }
    remark { '期間限定商品' }
    created_at { Time.current }
    association :user
    maker { FactoryBot.create(:maker, user: user) }
    producttype { FactoryBot.create(:producttype,user: user) } 
  end

  # システムスペック用のテストデータ--------------------------------------------
  # 年次集計用
  factory :yearly_aggregate_sale, class: Sale do
    amount_sold { 1000 }
    sequence(:remark) { |n| "Test yearly_aggregate #{n}" }
    # 2022年の1月〜12月の売り上げデータを月毎に１件ずつ生成
    sequence(:created_at) { |n| Time.zone.local(2021, 12, 1).next_month(n) } 
    user 
    maker
    producttype
  end 

  # 月次集計用
  factory :monthly_aggregate_sale, class: Sale do
    amount_sold { 1000 }
    sequence(:remark) { |n| "Test monthly_aggregate #{n}" }
    # 2022年の1月から売り上げデータを生成していく
    sequence(:created_at) { |n| Time.zone.local(2021, 12, 31).next_day(n)  } 
    user 
    maker
    producttype
  end 

  # 日次集計用
  factory :daily_aggregate_sale, class: Sale do
    amount_sold { 1000 }
    sequence(:remark) { |n| "Test daily_aggregate #{n}" }
    # 2022年の12月の売り上げデータを生成
    sequence(:created_at) { |n| Time.zone.local(2021, 12, 31).next_day(n) } 
    user 
    maker
    producttype
  end 
end
