require 'net/http'

class StaticPagesController < ApplicationController
  def home
    if logged_in?
      today = Time.zone.today
      
      sales = current_user.sales.where(created_at: today.all_day)
      if sales.present?
        # 売上推移の取得
        @sales_trend        = sales.group_by_hour(:created_at, range: today.all_day).sum(:amount_sold)
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
      "/v1/forecast?latitude=31.9167&longitude=131.4167&hourly=temperature_2m,precipitation_probability,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=Asia%2FTokyo&start_date=#{today.to_s}&end_date=#{today.to_s}",
      'Content-Type' => 'application/json'
      )
      # httpsで通信をする場合はuse_sslをtrueにする必要がある。
      http_client.use_ssl = true
      # requestメソッドの引数にNet::HTTPRequestを渡し、Net:HTTP:Responseオブジェクトを受け取る。
      response = http_client.request(get_request)
      # responseはJSON形式となっているので、JSON.parseでHashに変換する必要がある。
      @data = JSON.parse(response.body)
    end
  end
end
