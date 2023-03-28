class MakersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @makers = @user.makers.order("id DESC").page(params[:page]).per(10)
  end

  def new
    @maker = @user.makers.build
  end

  def create
    @maker = @user.makers.build(maker_params)
    if @maker.save
      flash[:success] = 'メーカーの追加に成功しました。'
      redirect_to user_makers_path(@user)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @maker = @user.makers.find(params[:id])
  end

  def update
    @maker = @user.makers.find(params[:id])
    if @maker.update(maker_params)
      flash[:success] = 'メーカーの編集に成功しました。'
      redirect_to user_makers_path(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private 
  # ストロングパラメータ
  def maker_params
    params.require(:maker).permit(:name)
  end
end
