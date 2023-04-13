class SalesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @sales = @user.sales.order("id").page(params[:page]).per(10)
  end

  def new
    @sale = @user.sales.build
  end

  def create
    @sale = @user.sales.build(sale_params)
    if @sale.save
      flash[:success] = '売上登録に成功しました。'
      redirect_to user_sales_path(@user), status: :see_other
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @sale = @user.sales.find(params[:id])
  end

  def update
    @sale = @user.sales.find(params[:id])
    if @sale.update(sale_params)
      flash[:success] = '編集に成功しました。'
      redirect_to user_sales_path(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user.sales.find(params[:id]).destroy
    flash[:success] = "売上情報を削除しました。"
    redirect_to user_sales_path(@user), status: :see_other
  end

  # 集計画面のアクション
  def aggregate_result
    # ①メーカー、商品別　②メーカー別　③商品別で販売合計額と販売数量を集計する
    date = "#{params[:month]}-01"
    # デバッグ用
    # puts "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■#{date}■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"

    @sales = @user.sales.where(created_at: date.in_time_zone.all_month)
    @aggregates_of_maker_producttype = @sales.joins(:maker, :producttype).select('makers.name as maker_name,
                                                                                  producttypes.name as producttype_name,
                                                                                  sum(sales.amount_sold) as sum_amount_sold,
                                                                                  count(*) as quantity_sold' ).group('maker_name, producttype_name').order('sum_amount_sold DESC')
    @aggregates_of_maker             = @sales.joins(:maker).select('makers.name as name,
                                                                    sum(sales.amount_sold) as sum_amount_sold,
                                                                    count(*) as quantity_sold').group('name').order('sum_amount_sold DESC')
    @aggregates_of_producttype       = @sales.joins(:producttype).select('producttypes.name as name,
                                                                          sum(sales.amount_sold) as sum_amount_sold,
                                                                          count(*) as quantity_sold' ).group('name').order('sum_amount_sold DESC')
    @aggregates_of_sales             = @sales.group_by_day(:created_at).sum(:amount_sold)
  end


  private
  # ストロングパラメータ
  def sale_params
    params.require(:sale).permit(:amount_sold, :remark, :maker_id, :producttype_id, :created_at)
  end

end
