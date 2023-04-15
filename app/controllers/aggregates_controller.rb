class AggregatesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  # 月別集計画面
  def month_aggregate
    @date = AggregateForm.new
  end

  # 月別集計画面での検索アクション
  def month_search
    # 入力した月をもとに売上情報を抽出。
    @date = AggregateForm.new(month: params[:month])

    if @date.valid?
      @sales = @user.sales.where(created_at: "#{@date.month}-01".in_time_zone.all_month)

      if !@sales.blank?
        # ①メーカー、商品別　②メーカー別　③商品別で販売合計額と販売数量を集計する
        @aggregates_of_maker_producttype = @sales.maker_producttype_sum_amount_sold.sorted
        @aggregates_of_maker             = @sales.maker_sum_amount_sold.sorted
        @aggregates_of_producttype       = @sales.producttype_sum_amount_sold.sorted
        # 日別の月別の販売合計額を集計する
        @daily_sum_amount_sold           = @sales.group_by_day(:created_at).sum(:amount_sold)
        @month_sum_amount_sold           = @sales.sum(:amount_sold)
      else
        # flash.now[:danger]= '対象月のデータはありません。'
        @date.errors.add(:month, 'のデータがありません。')
      end

      render 'month_aggregate'
    else
      render 'month_aggregate'
    end
  end


end
