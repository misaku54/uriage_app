class MakersController < ApplicationController
  def index
    @makers = Maker.all.page(params[:page]).per(10)
  end

  def new
  end

  def edit
  end
end
