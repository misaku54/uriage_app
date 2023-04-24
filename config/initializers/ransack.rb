Ransack.configure do |config|
  # predicateの定義　終了日の最終時間以下
  config.add_predicate 'lteq_end_of_day',
                        arel_predicate: 'lteq',
                        formatter: proc { |v| v.end_of_day }
end