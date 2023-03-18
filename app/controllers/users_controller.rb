class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]

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
      # ユーザー登録時にログインする
      log_in @user
      flash[:success] = '新規登録に成功しました。'
      redirect_to @user
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

    def logged_in_user
      unless logged_in?
        flash[:danger] = 'ログインしてください。'
        redirect_to login_path, status: :see_other
      end
    end
end