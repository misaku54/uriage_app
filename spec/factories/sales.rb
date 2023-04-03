FactoryBot.define do
  factory :sale do
    amount_sold { 10000 }
    remark { '期間限定商品' }
    association :maker
    producttype { FactoryBot.create(:producttype,user: maker.user) } 
    user { maker.user }
  end
end
