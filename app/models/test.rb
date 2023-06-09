class Test
  attr_reader :sales, :aggregates_of_maker_producttype, :aggregates_of_maker, :aggregates_of_producttype, :sales_trend, :sales_total_amount, :sales_growth_rate

  # コントローラーのロジックを書く
  def initialize(start_date:, end_date:, last_year_start_date:, last_year_end_date:, user:, type: )
    @start_date = start_date
    @end_date   = end_date
    @last_year_start_date = last_year_start_date
    @last_year_end_date = last_year_end_date
    @user = user
    @type = type
    @sales = nil
    @aggregates_of_maker_producttype =  nil
    @aggregates_of_maker             = nil
    @aggregates_of_producttype = nil
    @sales_trend = nil
    @sales_total_amount  = nil
    @sales_growth_rate = nil
  end

  def call
    set_sales
    set_aggregates_of_maker_producttype
    set_aggregates_of_maker
    set_aggregates_of_producttype
    set_sales_total_amount
    set_grouth_rate
    set_sales_trend
  end

  private 

  def set_sales
    @sales = @user.sales.where(created_at: @start_date..@last_date)
  end

  def set_aggregates_of_maker_producttype
    # binding.irb
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
    @sales_growth_rate                = Sale.sales_growth_rate(@sales_total_amount, last_year_sales_total_amount)        
  end

  def set_sales_trend
    case @type
    when 'day'
      @sales_trend = @sales.group_by_day(:created_at, range: @start_date..@end_date).sum(:amount_sold)
    when 'month'
      @sales_trend = @sales.group_by_month(:created_at, range: @start_date..@end_date).sum(:amount_sold)
    when 'year'
      @sales_trend = @sales.group_by_day(:created_at, range: @start_date..@end_date).sum(:amount_sold)
    end
  end
end