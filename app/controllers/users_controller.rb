class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user,   only: [:show, :edit, :update]

  def show
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

    # beforeフィルタ

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = 'ログインしてください。'
        redirect_to login_path, status: :see_other
      end
    end

    # 遷移したページのidがログインユーザー本人でなければ、ホーム画面へリダイレクト
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end
end