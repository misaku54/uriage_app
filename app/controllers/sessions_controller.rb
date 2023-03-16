class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが違います。'
      render 'new', status: :unprocessable_entity
    end
  end
end
