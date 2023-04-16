class AggregatesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  # 月別集計画面
  def monthly_aggregate
    @search_params = SearchForm.new
  end

  # 月別集計画面での検索アクション
  def monthly_search
    # 入力した月をもとに売上情報を抽出。
    @search_params = SearchForm.new(search_params)
    if @search_params.valid?
      @sales = @user.sales.where(created_at: @search_params.date.in_time_zone.all_month)
      # 取得したリレーションオブジェクトが空でなければ集計処理を実行する。
      if !@sales.blank?
        # ①メーカー、商品別　②メーカー別　③商品別で販売合計額と販売数量を集計する
        @aggregates_of_maker_producttype = @sales.maker_producttype_sum_amount_sold.sorted
        @aggregates_of_maker             = @sales.maker_sum_amount_sold.sorted
        @aggregates_of_producttype       = @sales.producttype_sum_amount_sold.sorted
        # 日別の月別の販売合計額を集計する
        @daily_sum_amount_sold           = @sales.group_by_day(:created_at).sum(:amount_sold)
        @month_sum_amount_sold           = @sales.sum(:amount_sold)
      else
        @search_params.errors.add(:date, 'に該当するデータがありません。')
      end
      render 'monthly_aggregate'
    else
      render 'monthly_aggregate'
    end
  end

  # 年別集計画面
  def year_aggregate
    @date = SearchYear.new
  end

  # 年別集計画面での検索アクション
  def year_search
    # 入力した年をもとに売上情報を抽出
    @date = SearchYear.new(year: params[:year])

    # 取得したリレーションオブジェクトが空でなければ集計処理を実行する。
    if @date.valid?
      @sales = @user.sales.where(created_at: "#{@date.year}-01-01".in_time_zone.all_year)

      # 取得したリレーションオブジェクトが空でなければ集計処理を実行する。
      if !@sales.blank?
        # ①メーカー、商品別　②メーカー別　③商品別で販売合計額と販売数量を集計する
        @aggregates_of_maker_producttype = @sales.maker_producttype_sum_amount_sold.sorted
        @aggregates_of_maker             = @sales.maker_sum_amount_sold.sorted
        @aggregates_of_producttype       = @sales.producttype_sum_amount_sold.sorted
        # 日別の月別の販売合計額を集計する
        @daily_sum_amount_sold           = @sales.group_by_month(:created_at).sum(:amount_sold)
        @month_sum_amount_sold           = @sales.sum(:amount_sold)
      else
        @date.errors.add(:year, 'のデータがありません。')
      end
      render 'year_aggregate'
    else
      render 'year_aggregate'
    end
  end


  def search_params
    params.permit(:date)
  end
end
