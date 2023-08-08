namespace :open_meteo_api do
  desc 'リクエストで連携してきたAPI項目をDBに保存する'
  task weather_forecasts: :environment do
    today = Time.zone.today
    api = OpenMeteoService.new
    result = api.get_weather_info(today)
    # データが取れなかった場合、標準出力にエラーを出す。
    return puts "API連携エラー:#{result[:reason]}" if result[:error]
    

  end
end
