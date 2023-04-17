class SearchForm
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment
  attr_accessor :date
  validates :date, presence: true

  # date_selectで分割されたパラメータをひとつのパラメータ（:date）にまとめる。
  def initialize(params = {})
    if params.is_a?(ActionController::Parameters)
      [:date].each do |attribute|
        date_parts = (1..3).map { |i| params.delete("#{attribute}(#{i}i)") }
        params[attribute]= Time.zone.local(*date_parts) if date_parts.any?
      end
    end
    super
  end

  # 集計条件で指定された期間を抽出
  def in_time_zone_all(period)
    if period == 'yearly'
      date.in_time_zone.all_year
    elsif period == 'monthly'
      date.in_time_zone.all_month
    end
  end
end