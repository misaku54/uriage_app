FactoryBot.define do
  factory :sale do
    amount_sold { 10000 }
    remark { '期間限定商品' }
    created_at { Time.current }
    association :user
    maker { FactoryBot.create(:maker, user: user) }
    producttype { FactoryBot.create(:producttype,user: user) } 
  end

  factory :aggregate_sale, class: Sale do
    amount_sold { 1000 }
    user 
    maker
    producttype

    # 年別集計のテストで使用するデータを用意
    trait :yearly_this_year do
      sequence(:created_at) { |n| Time.zone.local(2021, 12, 1).next_month(n) } 
    end
    trait :yearly_last_year do
      amount_sold { 500 }
      sequence(:created_at) { |n| Time.zone.local(2020, 12, 1).next_month(n)  } 
    end

    # 月別集計のテストで使用するデータを用意
    trait :monthly_this_year do
      sequence(:created_at) { |n| Time.zone.local(2021, 12, 31).next_day(n) } 
    end
    trait :monthly_last_year do
      amount_sold { 500 }
      sequence(:created_at) { |n| Time.zone.local(2020, 12, 31).next_day(n)  } 
    end

    # 日別集計のテストで使用するデータを用意
    trait :daily_this_year do
      sequence(:created_at) { |n| Time.zone.local(2021, 12, 31).next_day(n) } 
    end
    trait :daily_last_year do
      amount_sold { 500 }
      sequence(:created_at) { |n| Time.zone.local(2020, 12, 31).next_day(n)  } 
    end
  end 
end
