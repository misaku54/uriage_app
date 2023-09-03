class MakersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :set_maker, only: %i[edit update destroy]
  before_action :set_search_query, only: %i[index search export_csv]
  MAX_DISPLAY_COUNT = 10

  def index
    @makers = @q.result.page(params[:page]).per(MAX_DISPLAY_COUNT)
  end

  def search
    @makers = @q.result.page(params[:page]).per(MAX_DISPLAY_COUNT)
  end

  def export_csv
    @makers = @q.result
    send_data(CsvExport.maker_csv_output(@makers), filename: "#{Time.zone.now.strftime('%Y%m%d')}_makers.csv",
                                                   type: :csv)
  end

  def new
    @maker = @user.makers.build
  end

  def edit; end

  def create
    @maker = @user.makers.build(maker_params)
    if @maker.save
      flash[:success] = '登録しました。'
      redirect_to user_makers_path(@user), status: :see_other
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @maker.update(maker_params)
      flash[:success] = '更新しました。'
      redirect_to user_makers_path(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @maker.destroy
    flash[:success] = '削除しました。'
    redirect_to user_makers_path(@user), status: :see_other
  end

  private

  # ストロングパラメータ
  def maker_params
    params.require(:maker).permit(:name)
  end

  def set_maker
    @maker = @user.makers.find(params[:id])
  end

  def set_search_query
    @q = @user.makers.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
  end
end
