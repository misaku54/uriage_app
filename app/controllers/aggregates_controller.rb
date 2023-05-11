class AggregatesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  # 月別集計画面
  def monthly_aggregate
    @search_params = SearchForm.new
  end

  # 月別集計画面での検索アクション
  def monthly_search
    @search_params = SearchForm.new(search_params)
    # 入力パラメータチェック
    if @search_params.valid?
      sales = @user.sales.where(created_at: @search_params.date.all_month)
      # 入力パラメータの期間でデータがあれば集計処理をする、なければメッセージを通知
      if sales.present?
        # 集計用SQLに渡すパラメータを設定
        start_date                       = @search_params.date.beginning_of_month
        end_date                         = @search_params.date.end_of_month
        last_year_start_date             = @search_params.date.prev_year.beginning_of_month
        last_year_end_date               = @search_params.date.prev_year.end_of_month

        # ①メーカー、商品別　②メーカー別　③商品別で
        # 合計販売額、合計販売数、前年合計販売額、合計販売数、売上成長率をそれぞれ集計する
        # ここの集計だけ、クエリインターフェースでの実装が難しかったので、生SQLで実行している。
        @aggregates_of_maker_producttype = Sale.maker_id_and_producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_maker             = Sale.maker_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_producttype       = Sale.producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)

        # 売上推移の取得
        @sales_trend                     = sales.group_by_day(:created_at, range: start_date..end_date).sum(:amount_sold)
        # 売上合計額の取得
        @sales_total_amount              = sales.sum(:amount_sold)
        # 前年との売上成長率の取得
        last_year_sales                  = @user.sales.where(created_at: @search_params.date.prev_year.all_month)
        last_year_sales_total_amount     = last_year_sales.sum(:amount_sold)
        @sales_growth_rate               = Sale.sales_growth_rate(@sales_total_amount, last_year_sales_total_amount)
      else
        @no_result = "集計期間に該当する売上データがありません。"
      end
      render 'monthly_aggregate'
    else
      render 'monthly_aggregate'
    end
  end

  # 年別集計画面
  def yearly_aggregate
    @search_params  = SearchForm.new
  end

  # 年別集計画面での検索アクション
  def yearly_search
    @search_params  = SearchForm.new(search_params)
    # 入力パラメータチェック
    if @search_params.valid?
      sales = @user.sales.where(created_at: @search_params.date.all_year)
      # 入力パラメータの期間でデータがあれば集計処理をする、なければメッセージを通知
      if sales.present?
        # 集計用SQLに渡すパラメータを設定
        start_date                       = @search_params.date.beginning_of_year
        end_date                         = @search_params.date.end_of_year
        last_year_start_date             = @search_params.date.prev_year.beginning_of_year
        last_year_end_date               = @search_params.date.prev_year.end_of_year

        # ①メーカー、商品別　②メーカー別　③商品別で
        # 合計販売額、合計販売数、前年合計販売額、合計販売数、売上成長率をそれぞれ集計する
        # 上記の３つの集計だけ、クエリインターフェースでの実装が難しかったので、生SQLで実行している。
        @aggregates_of_maker_producttype = Sale.maker_id_and_producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_maker             = Sale.maker_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_producttype       = Sale.producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
    
        # 売上推移の取得
        @sales_trend                     = sales.group_by_month(:created_at, range: start_date..end_date).sum(:amount_sold)
        # 売上合計額の取得
        @sales_total_amount              = sales.sum(:amount_sold)
        # 前年との売上成長率の取得
        last_year_sales                  = @user.sales.where(created_at: @search_params.date.prev_year.all_year)
        last_year_sales_total_amount     = last_year_sales.sum(:amount_sold)
        @sales_growth_rate               = Sale.sales_growth_rate(@sales_total_amount, last_year_sales_total_amount)
      else
        @no_result = "集計期間に該当する売上データがありません。"
      end
      render 'yearly_aggregate'
    else
      render 'yearly_aggregate'
    end
  end

  # 日別集計画面
  def daily_aggregate
    @search_params = SearchDaily.new
  end

  # 日別集計画面での検索アクション
  def daily_search
    @search_params  = SearchDaily.new(search_params)
    # 入力パラメータチェック
    if @search_params.valid?
      sales = @user.sales.where(created_at: [@search_params.start_date.in_time_zone.beginning_of_day..@search_params.end_date.in_time_zone.end_of_day])
      # 入力パラメータの期間でデータがあれば集計処理をする、なければメッセージを通知
      if sales.present?
        # 集計用SQLに渡すパラメータを設定
        start_date                       = @search_params.start_date.in_time_zone.beginning_of_day
        end_date                         = @search_params.end_date.in_time_zone.end_of_day
        last_year_start_date             = @search_params.start_date.in_time_zone.prev_year.beginning_of_day
        last_year_end_date               = @search_params.end_date.in_time_zone.prev_year.end_of_day

        # ①メーカー、商品別　②メーカー別　③商品別で
        # 合計販売額、合計販売数、前年合計販売額、合計販売数、売上成長率をそれぞれ集計する
        # ここの集計だけ、クエリインターフェースでの実装が難しかったので、生SQLで実行している。
        @aggregates_of_maker_producttype = Sale.maker_id_and_producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_maker             = Sale.maker_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_producttype       = Sale.producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        
        # 売上推移の取得
        @sales_trend                     = sales.group_by_day(:created_at, range: start_date..end_date).sum(:amount_sold)
        # 売上合計額の取得
        @sales_total_amount              = sales.sum(:amount_sold)
        # 前年との売上成長率の取得
        last_year_sales                  = @user.sales.where(created_at: [last_year_start_date..last_year_end_date])
        last_year_sales_total_amount     = last_year_sales.sum(:amount_sold)
        @sales_growth_rate               = Sale.sales_growth_rate(@sales_total_amount, last_year_sales_total_amount)        
      else
        @no_result = "集計期間に該当する売上データがありません。"
      end
      render 'daily_aggregate'
    else
      render 'daily_aggregate'
    end
  end

  def today_aggregate
    sales = @user.sales.where(created_at: Time.zone.now.all_day)
    if sales.present?
      # 売上推移の取得
      @sales_trend        = sales.group_by_hour(:created_at, range: Time.zone.now.all_day).sum(:amount_sold)
      # 売上合計額の取得
      @sales_total_amount = sales.sum(:amount_sold)
    end
  end


  private

  # ストロングパラメータ
  def search_params
    params.permit(:date, :start_date, :end_date)
  end

end
