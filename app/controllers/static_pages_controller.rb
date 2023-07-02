class StaticPagesController < ApplicationController
  def home
    if logged_in?
      today = Time.zone.now
      sales = current_user.sales.where(created_at: today.all_day)
      if sales.present?
        # 売上推移の取得
        @sales_trend        = sales.group_by_hour(:created_at, range: today.all_day).sum(:amount_sold)
        # 売上合計額の取得
        @sales_total_amount = sales.sum(:amount_sold)
      end

      # 天気APIとの連携

    end
  end
end
