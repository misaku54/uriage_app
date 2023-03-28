class MakersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: [:index, :show, :new, :create]

  def index
    # @user   = User.find(params[:user_id])
    @makers = @user.makers.order("id DESC").page(params[:page]).per(10)
  end

  def new
    # @user  = User.find(params[:user_id])
    @maker = @user.makers.build
  end

  def create
    # @user  = User.find(params[:user_id])
    @maker = @user.makers.build(maker_params)
    if @maker.save
      flash[:success] = 'メーカーの追加に成功しました。'
      redirect_to user_makers_path(@user)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  private 
  # ストロングパラメータ
  def maker_params
    params.require(:maker).permit(:name)
  end
end
