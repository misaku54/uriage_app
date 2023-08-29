class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'ログインしてください。'
    redirect_to login_path, status: :see_other
  end

  # 遷移したページのidがログインユーザー本人でなければ、ホーム画面へリダイレクト
  def correct_user
    @user = if params[:user_id]
              User.find_by(id: params[:user_id])
            else
              User.find_by(id: params[:id])
            end
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end
end
