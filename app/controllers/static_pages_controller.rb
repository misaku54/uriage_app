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

      # https://api.open-meteo.com/v1/forecast?latitude=31.9167&longitude=131.4167&hourly=temperature_2m,precipitation_probability,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=Asia%2FTokyo&start_date=2023-07-02&end_date=2023-07-02
      # 天気APIとの連携

    end
  end
end
