require 'net/http'

class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    user = current_user
    # 今日の日付と現在時刻（時間のみ）を取得
    today = Time.zone.now
    sales = user.sales.where(created_at: today.all_day)
    return if sales.blank?

    # 売上推移の取得
    @sales_trend = sales.group_by_hour(:created_at, range: today.all_day).sum(:amount_sold)
    # 売上合計額の取得
    @sales_total_amount = sales.sum(:amount_sold)
    # @events = user.events
    @events = Event.where(start_time: Time.now.beginning_of_month.beginning_of_week..
    Time.now.end_of_month.end_of_week)
  end
end
