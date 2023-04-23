class AggregatesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  # 月別集計画面
  def monthly_aggregate
    @search_params = SearchForm.new
  end

  # 月別集計画面での検索アクション
  def monthly_search
    # 入力した年月パラメータでフォームオブジェクトを生成
    @search_params = SearchForm.new(search_params)
    # 入力パラメータを検証し、成功の場合そのパラメータでリレーションオブジェクトを取得。失敗の場合、検証エラーを出力する。
    if @search_params.valid?
      @sales = @user.sales.where(created_at: @search_params.date.in_time_zone.all_month)

      # 取得したリレーションオブジェクトが空でなければ集計処理を実行する。
      if !@sales.blank?
        # 集計用SQLに渡すパラメータを設定
        start_date                       = @search_params.date.beginning_of_month
        end_date                         = @search_params.date.end_of_month
        last_year_start_date             = @search_params.date.prev_year.beginning_of_month
        last_year_end_date               = @search_params.date.prev_year.end_of_month

        # ①メーカー、商品別　②メーカー別　③商品別で合計販売額と合計販売数を集計する
        @aggregates_of_maker_producttype = Sale.maker_id_and_producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_maker             = Sale.maker_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_producttype       = Sale.producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        # 売上推移の取得
        @sales_trend                     = @sales.group_by_day(:created_at).sum(:amount_sold)
        # 売上合計額の取得
        @sales_total_amount              = @sales.sum(:amount_sold)
      else
        @search_params.errors.add(:date, 'に該当するデータがありません。')
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
    # 入力した年パラメータでフォームオブジェクトを生成
    @search_params  = SearchForm.new(search_params)
    # 入力パラメータを検証し、成功の場合そのパラメータでリレーションオブジェクトを取得。失敗の場合、検証エラーを出力する。
    if @search_params.valid?
      @sales = @user.sales.where(created_at: @search_params.date.in_time_zone.all_year)

      # 取得したリレーションオブジェクトが空でなければ集計処理を実行する。
      if !@sales.blank?
        # 集計用SQLに渡すパラメータを設定
        start_date                       = @search_params.date.beginning_of_year
        end_date                         = @search_params.date.end_of_year
        last_year_start_date             = @search_params.date.prev_year.beginning_of_year
        last_year_end_date               = @search_params.date.prev_year.end_of_year

        # ①メーカー、商品別　②メーカー別　③商品別で合計販売額と合計販売数を集計する
        @aggregates_of_maker_producttype = Sale.maker_id_and_producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_maker             = Sale.maker_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_producttype       = Sale.producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        # 売上推移の取得
        @sales_trend                     = @sales.group_by_month(:created_at).sum(:amount_sold)
        # 売上合計額の取得
        @sales_total_amount              = @sales.sum(:amount_sold)
      else
        @search_params.errors.add(:date, 'に該当するデータがありません。')
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
    # 入力した開始日と終了日パラメータでフォームオブジェクトを生成
    @search_params  = SearchDaily.new(search_params)
    puts "#{@search_params.start_date.class},#{@search_params.start_date}"
    # 入力パラメータを検証し、成功の場合そのパラメータでリレーションオブジェクトを取得。失敗の場合、検証エラーを出力する。
    if @search_params.valid?
      @sales = @user.sales.where(created_at: [@search_params.start_date.in_time_zone..@search_params.end_date.in_time_zone.end_of_day])

      # 取得したリレーションオブジェクトが空でなければ集計処理を実行する。
      if !@sales.blank?
        # 集計用SQLに渡すパラメータを設定
        start_date                       = @search_params.start_date.in_time_zone.beginning_of_day
        end_date                         = @search_params.end_date.in_time_zone.end_of_day
        last_year_start_date             = @search_params.start_date.in_time_zone.prev_year.beginning_of_day
        last_year_end_date               = @search_params.end_date.in_time_zone.prev_year.end_of_day

        # ①メーカー、商品別　②メーカー別　③商品別で合計販売額と合計販売数を集計する
        @aggregates_of_maker_producttype = Sale.maker_id_and_producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_maker             = Sale.maker_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        @aggregates_of_producttype       = Sale.producttype_id_each_total_sales(@user, start_date, end_date, last_year_start_date, last_year_end_date)
        # 売上推移の取得
        @sales_trend                     = @sales.group_by_day(:created_at).sum(:amount_sold)
        # 売上合計額の取得
        @sales_total_amount              = @sales.sum(:amount_sold)
      else
        @search_params.errors.add(:date, 'に該当するデータがありません。')
      end
      render 'daily_aggregate'
    else
      render 'daily_aggregate'
    end
  end

  private

  # ストロングパラメータ
  def search_params
    params.permit(:date, :start_date, :end_date)
  end

end
