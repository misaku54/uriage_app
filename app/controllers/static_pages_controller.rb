class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @user   = current_user
    @events = @user.events
    today   = Time.zone.now

    @sales_total_amount = @user.sales_sum(today)
    @sales_trend = @user.hourly_sales_sum(today)
  end
end
