class StaticPagesController < ApplicationController
  def home
    if logged_in?
      sales = current_user.sales.where(created_at: Time.zone.now.all_day)
      if sales.present?
        # 売上推移の取得
        @sales_trend        = sales.group_by_hour(:created_at, range: Time.zone.now.all_day).sum(:amount_sold)
        # 売上合計額の取得
        @sales_total_amount = sales.sum(:amount_sold)
      end
    end
  end
end
