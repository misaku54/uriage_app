# 集計処理ロジックモデル
class Aggregate
  # アクセサメソッド
  attr_reader :sales, :aggregates_of_maker_producttype, :aggregates_of_maker, :aggregates_of_producttype, :sales_trend, :sales_total_amount, :sales_growth_rate

  def initialize(start_date:, end_date:, last_year_start_date:, last_year_end_date:, user:, type: )
    @start_date = start_date
    @end_date   = end_date
    @last_year_start_date = last_year_start_date
    @last_year_end_date   = last_year_end_date
    @user  = user
    @type  = type
    @sales = nil
    @aggregates_of_maker_producttype = nil
    @aggregates_of_maker = nil
    @aggregates_of_producttype = nil
    @sales_trend = nil
    @sales_total_amount = nil
    @sales_growth_rate  = nil
  end

  def call
    set_sales
    # ①メーカー、商品別　②メーカー別　③商品別で
    # 合計販売額、合計販売数、前年合計販売額、合計販売数、売上成長率を集計した結果を取得する。
    # ①〜③の集計だけ、クエリインターフェースでの実装が難しかったので、生SQLで実行している。
    set_aggregates_of_maker_producttype
    set_aggregates_of_maker
    set_aggregates_of_producttype
    # 売上合計額の取得
    set_sales_total_amount
    # 前年との売上成長率の取得
    set_grouth_rate
    # 売上推移の取得
    set_sales_trend
  end

  private 

  def set_sales
    @sales = @user.sales.where(created_at: @start_date..@end_date)
  end

  def set_aggregates_of_maker_producttype
    @aggregates_of_maker_producttype = Sale.maker_id_and_producttype_id_each_total_sales(@user, @start_date, @end_date, @last_year_start_date, @last_year_end_date)
  end

  def set_aggregates_of_maker
    @aggregates_of_maker             = Sale.maker_id_each_total_sales(@user, @start_date, @end_date, @last_year_start_date, @last_year_end_date)
  end

  def set_aggregates_of_producttype
    @aggregates_of_producttype       = Sale.producttype_id_each_total_sales(@user, @start_date, @end_date, @last_year_start_date, @last_year_end_date)
  end

  def set_sales_total_amount
    @sales_total_amount              = @sales.sum(:amount_sold)
  end

  def set_grouth_rate
    last_year_sales_total_amount     = @user.sales.where(created_at: [@last_year_start_date..@last_year_end_date]).sum(:amount_sold)
    @sales_growth_rate               = Sale.sales_growth_rate(@sales_total_amount, last_year_sales_total_amount)        
  end

  def set_sales_trend
    case @type
    when 'day', 'month'
      @sales_trend = @sales.group_by_day(:created_at, range: @start_date..@end_date).sum(:amount_sold)
    when 'year'
      @sales_trend = @sales.group_by_month(:created_at, range: @start_date..@end_date).sum(:amount_sold)
    end
  end
end