class SessionsController < ApplicationController
  before_action :logged_in_check, only: %i[new create]

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      flash[:success] = 'ログインしました。'
      redirect_to forwarding_url || root_url
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが違います。'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

  def logged_in_check
    if logged_in?
      flash[:danger] = 'すでにログインしています。'
      redirect_to root_url, status: :see_other
    end
  end
end
