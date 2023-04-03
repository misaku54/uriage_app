class SalesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
  end

  def new
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
