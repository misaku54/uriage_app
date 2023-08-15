class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  # beforeアクション

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
    if params[:user_id]
      @user = User.find_by(params[:user_id])
    else
      @user = User.find_by(params[:id])
    end
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end
end
