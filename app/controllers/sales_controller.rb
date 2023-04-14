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

  def aggregate_result
    @date = AggregateForm.new
  end

  def aggregate
    # 入力した月をもとに売上情報を抽出。
    @date = AggregateForm.new(month: params[:month])

    if @date.valid?
      @sales = @user.sales.where(created_at: "#{@date.month}-01".in_time_zone.all_month)
      if !@sales.blank?
        # ①メーカー、商品別　②メーカー別　③商品別で販売合計額と販売数量を集計する
        @aggregates_of_maker_producttype = @sales.maker_producttype_sum_amount_sold.sorted
        @aggregates_of_maker             = @sales.maker_sum_amount_sold.sorted
        @aggregates_of_producttype       = @sales.producttype_sum_amount_sold.sorted
        @aggregates_of_sales             = @sales.group_by_day(:created_at).sum(:amount_sold)
      else
        flash.now[:danger]= '対象月のデータはありません。'
      end
      render 'aggregate_result'
    else
      render 'aggregate_result'
    end
  end


  private
  # ストロングパラメータ
  def sale_params
    params.require(:sale).permit(:amount_sold, :remark, :maker_id, :producttype_id, :created_at)
  end

end
