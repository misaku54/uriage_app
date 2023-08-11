namespace :open_meteo_api do
  desc 'リクエストでAPIから取得した項目をDBに保存する'
  task set_weather_forecasts: :environment do
    Rails.logger.info("API連携:スタート")
    retry_count = 0

    begin
      time = Benchmark.realtime do
        # 天気APIサービスクラスの呼び出し
        today  = Time.zone.today
        api    = OpenMeteoService.new
        result = api.get_weather_info(today)
        return Rails.logger.error("API連携:連携はできましたが、JSONの取得に失敗しました。（#{result[:reason]}）") if result[:error]
        params = OpenMeteoService.attributes_for(result)

        # 天気予報DBに取得した日付が存在するか
        if weather_forecast = WeatherForecast.find_by(aquired_on: params[:aquired_on]).presence 
          weather_forecast.update!(params)
          Rails.logger.info("API連携:1件更新 #{params}")
        else
          WeatherForecast.create!(params)
          Rails.logger.info("API連携:1件追加 #{params}")
        end
      end
      Rails.logger.info("API連携:正常終了しました #{time}s")
    rescue RuntimeError => e
      retry_count += 1 
      if retry_count <= 3
        Rails.logger.info('API連携:RuntimeErrorが発生しました。')
        Rails.logger.info("API連携:retryします。（#{retry_count}回目）")
        retry
      else
        Rails.logger.info("API連携:3回のretryに失敗したため、エラー内容を出力します。")
        Rails.logger.info("ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー")
        Rails.logger.info(e.full_message)
        Rails.logger.info("ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー")
        Rails.logger.info("API連携:異常終了")
      end
    end 
  end
end
