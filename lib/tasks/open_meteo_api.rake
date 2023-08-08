namespace :open_meteo_api do
  desc 'リクエストで連携してきたAPI項目をDBに保存する'
  task weather_forecasts: :environment do
    today = Time.zone.today
    
  end
end
