class Admin::UsersController < ApplicationController
  before_action :logged_in_user

  def index
    @users = User.all
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
      reset_session
      flash[:success] = 'ユーザー情報の登録に成功しました。'
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      flash[:success] = '編集に成功しました。'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private 
  # ストロングパラメーター
  def user_params
    params.require(:user).permit(:name, :email, :password, 
                                                :password_confirmation)
  end

end
