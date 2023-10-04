# Rails.rootを使用するために必要。なぜなら、wheneverは読み込まれるときにrailsを起動する必要がある
require File.expand_path(File.dirname(__FILE__) + "/environment")

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所。ここでエラー内容を確認する
set :output, "#{Rails.root}/log/cron.log"
job_type :rake, 'cd :path && :environment_variable=:environment bundle exec rake :task :output'
ENV.each { |k, v| env(k, v) } # これを追加

# 3時間ごとに[lib/tasks/open_meteo_api.rake]を実行する
# every 3.hours do
every 1.minutes do
  rake 'open_meteo_api:set_weather_forecasts'
end

