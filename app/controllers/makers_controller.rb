class MakersController < ApplicationController
  def index
    @makers = Maker.order("id DESC").page(params[:page]).per(10)
  end

  def new
    @user = User.find(params[:user_id])
    @maker = @user.makers.build
  end

  def edit
  end
end
