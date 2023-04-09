FactoryBot.define do
  factory :sale do
    amount_sold { 10000 }
    remark { '期間限定商品' }
    created_at { Time.current }
    # association :maker
    # producttype { FactoryBot.create(:producttype,user: maker.user) } 
    # user { maker.user }
    association :user
    maker { FactoryBot.create(:maker,user: user) }
    producttype { FactoryBot.create(:producttype,user: user) } 
  end
end
