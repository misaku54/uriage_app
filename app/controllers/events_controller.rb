class EventsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def new
    @event = @user.events.build
    puts params[:default_date].to_date
    @default_date = params[:default_date].to_date
  end

  def edit
    @event = @user.events.find(params[:id])
  end

  def create
    @event = @user.events.build(event_params)
    if @event.save
      flash[:success] = '登録しました。'
      redirect_to root_url, status: :see_other
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    @event = @user.events.find(params[:id])
    if @event.update(event_params)
      flash[:success] = '更新しました。'
      redirect_to root_url, status: :see_other
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user.events.find(params[:id]).destroy
    flash[:success] = '削除しました。'
    redirect_to root_url, status: :see_other
  end

  private

  # ストロングパラメータ
  def event_params
    params.require(:event).permit(:title, :content, :start_time, :end_time)
  end
end
