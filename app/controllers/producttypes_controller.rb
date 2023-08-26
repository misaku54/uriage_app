class ProducttypesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :set_search_query, only: [:index, :search, :export_csv]
  MAX_DISPLAY_COUNT = 10

  def index
    @producttypes = @q.result.page(params[:page]).per(MAX_DISPLAY_COUNT)
  end

  def search
    @producttypes = @q.result.page(params[:page]).per(MAX_DISPLAY_COUNT)
  end

  def export_csv
    @producttypes = @q.result
    send_data(CsvExport.producttype_csv_output(@producttypes), filename: "#{Time.zone.now.strftime("%Y%m%d")}_producttypes.csv", type: :csv)
  end

  def new
    @producttype = @user.producttypes.build
  end

  def create
    @producttype = @user.producttypes.build(producttype_params)
    if @producttype.save
      flash[:success] = '登録しました。'
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
      flash[:success] = '更新しました。'
      redirect_to user_producttypes_path(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user.producttypes.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to user_producttypes_path(@user), status: :see_other
  end

  private 
  # ストロングパラメータ
  def producttype_params
    params.require(:producttype).permit(:name)
  end

  def set_search_query
    @q = @user.producttypes.ransack(params[:q])
  end
end
