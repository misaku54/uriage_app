namespace :open_meteo_api do
  desc 'リクエストで連携してきたAPI項目をDBに保存する'
  task weather_forecasts: :environment do
    today = Time.zone.today
    api = OpenMeteoService.new
    result = api.get_weather_info(today)

    # データが取れなかった場合、標準出力にエラーを出す。
    return puts "API連携エラー:#{result[:reason]}" if result[:error]
    params = WeatherForecast.attributes_for(result)
    if weather_forecast = WeatherForecast.find_by(aquired_on: params[:aquired_on]).presence #rails固有ActiveSupportのメソッド　あれば、オブジェクトをそのまま、なければnilを返す。

  end
end
