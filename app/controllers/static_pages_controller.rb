class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    today   = Time.zone.now
    
    @user   = current_user
    @events = @user.events
    @sales_total_amount = @user.sales_sum(today)
    @sales_trend = @user.hourly_sales_sum(today)
  end
end
