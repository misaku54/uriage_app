class Admin::UsersController < ApplicationController
  before_action :if_not_admin

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザー情報の登録に成功しました。'
      redirect_to admin_user_path(@user)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = '編集に成功しました。'
      redirect_to admin_user_path(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private 
  # ストロングパラメーター
  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, 
                                                        :password_confirmation)
  end

  def if_not_admin
    redirect_to root_path unless current_user&.admin?
  end
end
