class SalesController < ApplicationController
  def index
  end

  def new
    @user   = User.find(params[:user_id])
    @makers = @user.makers
    @producttypes = @user.producttypes
    @sale   = @user.sales.build
  end

  def edit
  end


  private
  # ストロングパラメータ
  def sale_params
    params.require(:sale).permit(:amount_sold, :remark, :maker_id, :producttype_id)
  end
end
