require 'net/http'

class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # 今日の日付と現在時刻（時間のみ）を取得
      @today = Time.zone.today
      @hour  = Time.zone.now.strftime("%H").to_i

      sales = current_user.sales.where(created_at: @today.all_day)
      if sales.present?
        # 売上推移の取得
        @sales_trend        = sales.group_by_hour(:created_at, range: @today.all_day).sum(:amount_sold)
        # 売上合計額の取得
        @sales_total_amount = sales.sum(:amount_sold)
      end

      # 現在の天気情報の取得
      api = OpenMeteoService.new
      @data = api.get_weather_info(@today)
    end
  end
end