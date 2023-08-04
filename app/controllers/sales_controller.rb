class SalesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def show
    @sale = @user.sales.find(params[:id])
  end

  def index
    @q = @user.sales.ransack(params[:q])
    return generate_csv if params[:export_csv]
    @sales  = @q.result.page(params[:page]).per(10)
  end

  def new
    @sale = @user.sales.build
  end

  def create
    @sale = @user.sales.build(sale_params)
    if @sale.save
      flash[:success] = '登録しました。'
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
      flash[:success] = '更新しました。'
      redirect_to user_sales_path(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user.sales.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to user_sales_path(@user), status: :see_other
  end
  

  private
  # ストロングパラメータ
  def sale_params
    params.require(:sale).permit(:amount_sold, :remark, :maker_id, :producttype_id, :created_at)
  end

  def generate_csv
    @sales = @q.result
    send_data(CsvExport.sale_csv_output(@sales), filename: "#{Time.zone.now.strftime("%Y%m%d")}_売上一覧.csv")
  end
end
