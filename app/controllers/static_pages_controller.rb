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

      # 現在の天気情報を取得するロジック（あとでモデルかヘルパーに回す）
      api = OpenMeteoService.new
      @data = api.get_weather_info(@today)
      # 現在の時間を取得する。
      hour = Time.zone.now.strftime("%H").to_i
      puts @data[:hourly][:temperature_2m]
      puts "aaaaaaaaaaaaaaaaa#{@data[:hourly][:temperature_2m][hour]}"
    end
  end
end