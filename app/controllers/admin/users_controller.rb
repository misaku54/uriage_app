class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :if_not_admin

  def index
    @q = User.order('id').ransack(params[:q])
    @users = @q.result.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザーの登録に成功しました。'
      redirect_to admin_user_path(@user)
    else
      render 'new', status: :unprocessable_entity
    end
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'ユーザーを削除しました。'
    redirect_to admin_users_path, status: :see_other
  end

  private

  # ストロングパラメーター
  def user_params
    params.require(:user).permit(:name, :email, :admin, :password,
                                 :password_confirmation)
  end

  # 管理者かどうか確認
  def if_not_admin
    redirect_to(root_path, status: :see_other) unless current_user&.admin?
  end
end
