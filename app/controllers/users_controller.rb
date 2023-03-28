class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :index]
  before_action :correct_user,   only: [:show]

  def index
    @users = User.order("id DESC").page(params[:page]).per(10)
  end

  def show
  end
end