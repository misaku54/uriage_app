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
        # ①メーカー、商品別　②メーカー別　③商品別で販売合計額と販売数量を集計する
        @aggregates_of_maker_producttype = @sales.maker_producttype_sum_amount_sold.sorted
        @aggregates_of_maker             = @sales.maker_sum_amount_sold.sorted
        @aggregates_of_producttype       = @sales.producttype_sum_amount_sold.sorted
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
    sql_1 = <<-EOS
    SELECT k.maker_name, k.producttype_name, k.sum_amount_sold current_year_amount, k.quantity_sold current_year_quantity,
    z.sum_amount_sold last_year_amount, z.quantity_sold last_year_quantity
      FROM (SELECT m.name maker_name, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
        FROM sales s
        INNER JOIN makers m ON m.id = s.maker_id
        INNER JOIN producttypes p ON p.id = s.producttype_id
        WHERE s.user_id = :user_id AND s.created_at BETWEEN :current_year_start AND :current_year_end
        GROUP BY maker_name, producttype_name) k
      LEFT JOIN (SELECT m.name maker_name, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
        FROM sales s
        INNER JOIN makers m 
        ON m.id = s.maker_id
        INNER JOIN producttypes p 
        ON p.id = s.producttype_id
        WHERE s.user_id = :user_id AND s.created_at BETWEEN :last_year_start AND :last_year_end
        GROUP BY maker_name, producttype_name) z
      ON k.maker_name = z.maker_name AND k.producttype_name = z.producttype_name
      ORDER BY current_year_amount DESC
    EOS

    sql_2 = <<-EOS
    SELECT k.maker_name, k.sum_amount_sold current_year_amount, k.quantity_sold current_year_quantity,
    z.sum_amount_sold last_year_amount, z.quantity_sold last_year_quantity
      FROM (SELECT m.name maker_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
        FROM sales s
        INNER JOIN makers m 
        ON m.id = s.maker_id
        WHERE s.user_id = :user_id AND s.created_at BETWEEN :current_year_start AND :current_year_end
        GROUP BY maker_name) k
      LEFT JOIN (SELECT m.name maker_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
        FROM sales s
        INNER JOIN makers m 
        ON m.id = s.maker_id
        WHERE s.user_id = :user_id AND s.created_at BETWEEN :last_year_start AND :last_year_end
        GROUP BY maker_name) z
      ON k.maker_name = z.maker_name
      ORDER BY current_year_amount DESC
    EOS

    sql_3 = <<-EOS
    SELECT k.producttype_name, k.sum_amount_sold current_year_amount, k.quantity_sold current_year_quantity,
    z.sum_amount_sold last_year_amount, z.quantity_sold last_year_quantity
      FROM (SELECT p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
        FROM sales s
        INNER JOIN producttypes p 
        ON p.id = s.producttype_id
        WHERE s.user_id = :user_id AND s.created_at BETWEEN :current_year_start AND :current_year_end
        GROUP BY producttype_name) k
      LEFT JOIN (SELECT p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
        FROM sales s
        INNER JOIN producttypes p 
        ON p.id = s.producttype_id
        WHERE s.user_id = :user_id AND s.created_at BETWEEN :last_year_start AND :last_year_end
        GROUP BY producttype_name) z
      ON k.producttype_name = z.producttype_name
      ORDER BY current_year_amount DESC
    EOS

    # 入力した年パラメータでフォームオブジェクトを生成
    @search_params  = SearchForm.new(search_params)
    # 入力パラメータを検証し、成功の場合そのパラメータでリレーションオブジェクトを取得。失敗の場合、検証エラーを出力する。
    if @search_params.valid?
      @sales = @user.sales.where(created_at: @search_params.date.in_time_zone.all_year)

      # 取得したリレーションオブジェクトが空でなければ集計処理を実行する。
      if !@sales.blank?
        # ①メーカー、商品別　②メーカー別　③商品別で販売合計額と販売数量を集計する
        @aggregates_of_maker_producttype = Sale.maker_producttype_sum_amount_sold(@user, @search_params)
        @aggregates_of_maker             = Sale.maker_sum_amount_sold(@user, @search_params)
        @aggregates_of_producttype       = Sale.producttype_sum_amount_sold(@user, @search_params)
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
    # 入力パラメータを検証し、成功の場合そのパラメータでリレーションオブジェクトを取得。失敗の場合、検証エラーを出力する。
    if @search_params.valid?
      @sales = @user.sales.where(created_at: [@search_params.start_date.in_time_zone..@search_params.end_date.in_time_zone.end_of_day])

      # 取得したリレーションオブジェクトが空でなければ集計処理を実行する。
      if !@sales.blank?
        # ①メーカー、商品別　②メーカー別　③商品別で販売合計額と販売数量を集計する
        @aggregates_of_maker_producttype = @sales.maker_producttype_sum_amount_sold.sorted
        @aggregates_of_maker             = @sales.maker_sum_amount_sold.sorted
        @aggregates_of_producttype       = @sales.producttype_sum_amount_sold.sorted
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
