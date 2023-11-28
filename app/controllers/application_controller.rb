class ApplicationController < ActionController::Base
  include SessionsHelper
  TIMEOUT = 5.minutes

  private

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    if logged_in?
      time_out
      return
    end

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

  def time_out
    if session[:last_access_time] > TIMEOUT.ago
      session[:last_access_time] = Time.current
    else
      log_out
      flash[:danger] = "タイムアウトしました。"
      redirect_to login_path, status: :see_other
    end
  end
end
