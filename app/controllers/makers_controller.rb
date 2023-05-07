class MakersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @q = @user.makers.ransack(params[:q])
    @q.sorts = 'created_at asc' if @q.sorts.empty?
    @makers  = @q.result.page(params[:page]).per(10)
    @maker   = @user.makers.build
  end

  def show
    @maker = @user.makers.find(params[:id])
  end

  def new
    @maker = @user.makers.build
  end

  def create
    @maker = @user.makers.build(maker_params)
    if @maker.save
      flash[:success] = 'メーカーの追加に成功しました。'
      redirect_to user_makers_path(@user), status: :see_other
    else
      respond_to do |format|
        format.html { render 'new', status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def edit
    @maker = @user.makers.find(params[:id])
  end

  def update
    @maker = @user.makers.find(params[:id])
    if @maker.update(maker_params)
      # flash[:success] = '編集しました。'
      # redirect_to user_maker_path(@user), status: :see_other
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user.makers.find(params[:id]).destroy
    flash[:success] = "メーカーを削除しました。"
    redirect_to user_makers_path(@user), status: :see_other
  end


  private 
  # ストロングパラメータ
  def maker_params
    params.require(:maker).permit(:name)
  end
end
