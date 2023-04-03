class SalesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :set_makers_producttypes, only: [:new, :create]

  def index
  end

  def new
    @sale   = @user.sales.build
  end

  def create
    @sale   = @user.sales.build(sale_params)

    if @sale.save
      flash[:success] = '売上登録に成功しました。'
      # redirect_to user_sales_path(@user), status: :see_other
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end


  private
  # ストロングパラメータ
  def sale_params
    params.require(:sale).permit(:amount_sold, :remark, :maker_id, :producttype_id)
  end

  def set_makers_producttypes
    @makers = @user.makers
    @producttypes = @user.producttypes
  end
end
