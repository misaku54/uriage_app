class ProducttypesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @producttypes = @user.producttypes.order("id DESC").page(params[:page]).per(10)
  end

  def new
    @producttype = @user.producttypes.build
  end

  def create
    @producttype = @user.producttypes.build(producttype_params)
    if @producttype.save
      flash[:success] = '商品の追加に成功しました。'
      redirect_to user_producttypes_path(@user)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @producttype = @user.producttypes.find(params[:id])
  end

  def update
    @producttype = @user.producttypes.find(params[:id])
    if @producttype.update(producttype_params)
      flash[:success] = '編集に成功しました。'
      redirect_to user_producttypes_path(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user.producttypes.find(params[:id]).destroy
    flash[:success] = "商品を削除しました。"
    redirect_to user_producttypes_path(@user), status: :see_other
  end

  private 
  # ストロングパラメータ
  def producttype_params
    params.require(:producttype).permit(:name)
  end

end
