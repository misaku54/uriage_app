FactoryBot.define do
  factory :event do
    title { 'イベント' }
    content { 'イベント' }
    start_time { Time.zone.now }
    end_time { Time.zone.now }
    user
  end
end
