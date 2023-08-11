namespace :open_meteo_api do
  desc 'リクエストでAPIから取得した項目をDBに保存する'
  task set_weather_forecasts: :environment do
    puts "API連携:スタート"
    retry_count = 0
    begin
      time = Benchmark.realtime do
        # 天気APIサービスクラスの呼び出し
        today  = Time.zone.today
        api    = OpenMeteoService.new
        result = api.get_weather_info(today)
        # データが取れなかった場合、標準出力にエラーを出す。
        return puts "API連携:JSONの取得に失敗しました。（#{result[:reason]}）" if result[:error]
        params = OpenMeteoService.attributes_for(result)
        if weather_forecast = WeatherForecast.find_by(aquired_on: params[:aquired_on]).presence #rails固有ActiveSupportのメソッド　あれば、オブジェクトをそのまま、なければnilを返す。
          weather_forecast.update!(params)
          puts "API連携:1件更新 #{params}"
        else
          WeatherForecast.create!(params)
          puts "API連携:1件追加 #{params}"
        end
        puts "API連携:正常終了 #{time}s"
      end
    rescue RuntimeError => e
      retry_count += 1 
      if retry_count <= 3
        puts 'API連携:RuntimeErrorが発生しました。'
        puts "API連携:retryします。（#{retry_count}回目）"
        retry
      else
        puts "API連携:3回のretryに失敗したため、エラー内容を出力します。"
        puts "ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー"
        puts e.full_message
        puts "ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー"
        puts "API連携:異常終了"
      end
    end 
  end
end
