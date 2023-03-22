class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :index]
  before_action :correct_user,   only: [:show]

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
  end

  private 
    # beforeフィルタ

    # 遷移したページのidがログインユーザー本人でなければ、ホーム画面へリダイレクト
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end
end