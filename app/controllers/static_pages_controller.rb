require 'net/http'

class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @today = Time.zone.today
      
      sales = current_user.sales.where(created_at: @today.all_day)
      if sales.present?
        # 売上推移の取得
        @sales_trend        = sales.group_by_hour(:created_at, range: @today.all_day).sum(:amount_sold)
        # 売上合計額の取得
        @sales_total_amount = sales.sum(:amount_sold)
      end

      # 天気APIとの連携
      uri = URI.parse('https://api.open-meteo.com')
      # HTTPクラインとを生成し、引数にホスト名とポート番号を指定する。
      http_client = Net::HTTP.new(uri.host, uri.port)
      # Net::HTTPのGETリクエストクラスでインスタンスを生成
      # https://api.open-meteo.com/v1/forecast?latitude=31.9167&longitude=131.4167&hourly=temperature_2m,precipitation_probability,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_probability_max,windspeed_10m_max&timezone=Asia%2FTokyo&start_date=2023-07-04&end_date=2023-07-04
      get_request = Net::HTTP::Get.new(
      "/v1/forecast?latitude=31.9167&longitude=131.4167&hourly=temperature_2m,precipitation_probability,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=Asia%2FTokyo&start_date=#{@today}&end_date=#{@today}",
      'Content-Type' => 'application/json'
      )
      # httpsで通信をする場合はuse_sslをtrueにする必要がある。
      http_client.use_ssl = true
      # requestメソッドの引数にNet::HTTPRequestを渡し、Net:HTTP:Responseオブジェクトを受け取る。
      response = http_client.request(get_request)
      # responseはJSON形式となっているので、JSON.parseでHashに変換する必要がある。
      @data = JSON.parse(response.body)

      # 現在の天気情報を取得するロジック（あとでモデルかヘルパーに回す）
      
      # 現在の時間を取得する。
      hour = Time.zone.now.strftime("%H").to_i
      puts @data["hourly"]["temperature_2m"]
      puts "aaaaaaaaaaaaaaaaa#{@data["hourly"]["temperature_2m"][hour]}"
    end
  end
end
{"latitude"=>31.9, "longitude"=>131.4375, "generationtime_ms"=>0.5990266799926758, "utc_offset_seconds"=>32400, "timezone"=>"Asia/Tokyo", "timezone_abbreviation"=>"JST", "elevation"=>7.0, "hourly_units"=>{"time"=>"iso8601", "temperature_2m"=>"°C", "precipitation_probability"=>"%", "weathercode"=>"wmo code"}, "hourly"=>{"time"=>["2023-07-06T00:00", "2023-07-06T01:00", "2023-07-06T02:00", "2023-07-06T03:00", "2023-07-06T04:00", "2023-07-06T05:00", "2023-07-06T06:00", "2023-07-06T07:00", "2023-07-06T08:00", "2023-07-06T09:00", "2023-07-06T10:00", "2023-07-06T11:00", "2023-07-06T12:00", "2023-07-06T13:00", "2023-07-06T14:00", "2023-07-06T15:00", "2023-07-06T16:00", "2023-07-06T17:00", "2023-07-06T18:00", "2023-07-06T19:00", "2023-07-06T20:00", "2023-07-06T21:00", "2023-07-06T22:00", "2023-07-06T23:00"], "temperature_2m"=>[26.7, 26.5, 26.2, 26.1, 26.1, 26.0, 26.1, 26.3, 27.3, 28.9, 29.1, 28.7, 28.3, 28.2, 27.7, 27.3, 27.4, 27.5, 28.0, 28.2, 27.6, 27.1, 26.7, 26.5], "precipitation_probability"=>[0, 2, 4, 6, 17, 28, 39, 29, 20, 10, 7, 3, 0, 2, 4, 6, 9, 13, 16, 12, 7, 3, 3, 3], "weathercode"=>[1, 1, 3, 3, 2, 1, 2, 1, 1, 0, 1, 1, 1, 2, 2, 2, 3, 2, 2, 2, 3, 2, 1, 1]}, "daily_units"=>{"time"=>"iso8601", "weathercode"=>"wmo code", "temperature_2m_max"=>"°C", "temperature_2m_min"=>"°C"}, "daily"=>{"time"=>["2023-07-06"], "weathercode"=>[3], "temperature_2m_max"=>[29.1], "temperature_2m_min"=>[26.0]}}