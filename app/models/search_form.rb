class SearchForm
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment
  
  # バリデーション
  attr_accessor :date
  validates :date, presence: true

  # date_selectで分割されたパラメータをひとつのパラメータ（:date）にまとめる。
  def initialize(params = {})
    puts params
    if params.is_a?(ActionController::Parameters)
      date_parts = (1..3).map { |i| params.delete("#{:date}(#{i}i)") }
      params[:date]= Time.zone.local(*date_parts) if date_parts.any?
    end
    super
  end
end