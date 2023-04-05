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


  private
  # ストロングパラメータ
  def sale_params
    params.require(:sale).permit(:amount_sold, :remark, :maker_id, :producttype_id)
  end
end
