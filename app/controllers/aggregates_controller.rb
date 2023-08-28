class AggregatesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  # 月別集計画面
  def monthly_aggregate
    @search_params = SearchForm.new
  end

  # 月別集計画面での検索アクション
  def monthly_search
    @search_params = SearchForm.new(search_form_params)
    # 入力パラメータチェック
    if @search_params.valid?
      start_date                       = @search_params.date.in_time_zone.beginning_of_month
      end_date                         = @search_params.date.in_time_zone.end_of_month
      last_year_start_date             = @search_params.date.in_time_zone.prev_year.beginning_of_month
      last_year_end_date               = @search_params.date.in_time_zone.prev_year.end_of_month

      # 集計処理はロジックモデルで行う。
      aggregate = Aggregate.new(start_date: start_date, end_date: end_date, last_year_start_date: last_year_start_date, last_year_end_date: last_year_end_date, user: @user, type: 'month')
      aggregate.call
      sales = aggregate.sales
      
      # 入力パラメータの期間で売上データがあれば集計処理をする、なければメッセージを通知
      unless sales.present?
        @no_result = '集計期間に該当する売上データがありません。'
        render 'monthly_search' and return
      end

      # ロジックモデルで集計した値をビューで使用するインスタンス変数に格納する。
      @aggregates_of_maker_producttype = aggregate.aggregates_of_maker_producttype
      @aggregates_of_maker             = aggregate.aggregates_of_maker
      @aggregates_of_producttype       = aggregate.aggregates_of_producttype
      @sales_trend                     = aggregate.sales_trend
      @sales_total_amount              = aggregate.sales_total_amount
      @sales_growth_rate               = aggregate.sales_growth_rate

      return generate_csv if params[:export_csv]
    else
      render 'monthly_aggregate', status: :unprocessable_entity
    end
  end

  # 年別集計画面
  def yearly_aggregate
    @search_params  = SearchForm.new
  end

  # 年別集計画面での検索アクション
  def yearly_search
    @search_params  = SearchForm.new(search_form_params)
    # 入力パラメータチェック
    if @search_params.valid?      
      start_date                       = @search_params.date.in_time_zone.beginning_of_year
      end_date                         = @search_params.date.in_time_zone.end_of_year
      last_year_start_date             = @search_params.date.in_time_zone.prev_year.beginning_of_year
      last_year_end_date               = @search_params.date.in_time_zone.prev_year.end_of_year
      
      # 集計処理はロジックモデルで行う。
      aggregate = Aggregate.new(start_date: start_date, end_date: end_date, last_year_start_date: last_year_start_date, last_year_end_date: last_year_end_date, user: @user, type: 'year')
      aggregate.call
      sales = aggregate.sales

      # 入力パラメータの期間で売上データがあれば集計処理をする、なければメッセージを通知
      unless sales.present?
        @no_result = '集計期間に該当する売上データがありません。'
        render 'yearly_search' and return
      end 

      # ロジックモデルで集計した値をビューで使用するインスタンス変数に格納する。
      @aggregates_of_maker_producttype = aggregate.aggregates_of_maker_producttype
      @aggregates_of_maker             = aggregate.aggregates_of_maker
      @aggregates_of_producttype       = aggregate.aggregates_of_producttype
      @sales_trend                     = aggregate.sales_trend
      @sales_total_amount              = aggregate.sales_total_amount
      @sales_growth_rate               = aggregate.sales_growth_rate

      return generate_csv if params[:export_csv]
    else
      render 'yearly_aggregate', status: :unprocessable_entity
    end
  end

  # 日別集計画面
  def daily_aggregate
    @search_params = SearchDaily.new
  end

  # 日別集計画面での検索アクション
  def daily_search
    @search_params  = SearchDaily.new(search_daily_params)
    # 入力パラメータチェック
    if @search_params.valid?
      start_date                       = @search_params.start_date.in_time_zone.beginning_of_day
      end_date                         = @search_params.end_date.in_time_zone.end_of_day
      last_year_start_date             = @search_params.start_date.in_time_zone.prev_year.beginning_of_day
      last_year_end_date               = @search_params.end_date.in_time_zone.prev_year.end_of_day
      
      # 集計処理はロジックモデルで行う。
      aggregate = Aggregate.new(start_date: start_date, end_date: end_date, last_year_start_date: last_year_start_date, last_year_end_date: last_year_end_date, user: @user, type: 'day')
      aggregate.call
      sales = aggregate.sales

      # 入力パラメータの期間で売上データがあれば集計処理をする、なければメッセージを通知
      unless sales.present?
        @no_result = '集計期間に該当する売上データがありません。'
        render 'daily_search' and return
      end

      # ロジックモデルで集計した値をビューで使用するインスタンス変数に格納する。
      @aggregates_of_maker_producttype = aggregate.aggregates_of_maker_producttype
      @aggregates_of_maker             = aggregate.aggregates_of_maker
      @aggregates_of_producttype       = aggregate.aggregates_of_producttype
      @sales_trend                     = aggregate.sales_trend
      @sales_total_amount              = aggregate.sales_total_amount
      @sales_growth_rate               = aggregate.sales_growth_rate

      return generate_csv if params[:export_csv]
    else
      render 'daily_aggregate', status: :unprocessable_entity
    end
  end


  private

  # ストロングパラメータ
  # 日次と年次月次で検索フォームで渡す値の形式が異なるため、バリデーション用のフォームオブジェクトを２つ用意し、ストロングパラメータも二つ用意している。
  def search_form_params
    params.require(:search_form).permit(:date)
  end

  def search_daily_params
    params.require(:search_daily).permit(:start_date, :end_date)
  end

  # csv出力
  def generate_csv
    send_data(CsvExport.aggregate_csv_output(@sales_total_amount, @sales_growth_rate, @aggregates_of_maker_producttype, @aggregates_of_maker, @aggregates_of_producttype), filename: "#{Time.zone.now.strftime("%Y%m%d")}_shukei.csv", type: :csv)
  end
end
