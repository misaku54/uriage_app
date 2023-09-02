class SalesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :set_sale, only: %i[show edit update destroy]
  before_action :set_search_query, only: %i[index search export_csv]
  MAX_DISPLAY_COUNT = 10

  def index
    @sales = @q.result.page(params[:page]).per(MAX_DISPLAY_COUNT)
  end

  def search
    @sales = @q.result.page(params[:page]).per(MAX_DISPLAY_COUNT)
  end
  
  def export_csv
    @sales = @q.result
    send_data(CsvExport.sale_csv_output(@sales), filename: "#{Time.zone.now.strftime('%Y%m%d')}_sales.csv", type: :csv)
  end
  
  def show; end

  def new
    @sale = @user.sales.build
  end

  def edit; end

  def create
    @sale = @user.sales.build(sale_params)
    if @sale.save
      flash[:success] = '登録しました。'
      redirect_to user_sales_path(@user), status: :see_other
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @sale.update(sale_params)
      flash[:success] = '更新しました。'
      redirect_to user_sales_path(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @sale.destroy
    flash[:success] = '削除しました。'
    redirect_to user_sales_path(@user), status: :see_other
  end

  private

  # ストロングパラメータ
  def sale_params
    params.require(:sale).permit(:amount_sold, :remark, :maker_id, :producttype_id, :created_at, :create_on)
  end

  def set_sale
    @sale = @user.sales.find(params[:id])
  end
  def set_search_query
    @q = @user.sales.includes(:maker, :producttype, :weather).ransack(params[:q])
  end
end
