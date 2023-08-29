# 日別集計用フォームクラス
class SearchDaily
  include ActiveModel::Model

  # アクセサメソッド
  attr_accessor :start_date, :end_date

  # バリデーション
  validates :start_date, presence: true
  validates :end_date, presence: true
  
  # カスタムバリデーション
  validate :date_check # 開始日と終了日のチェック

  private

  def date_check
    if start_date.present? && end_date.present?
      if end_date < start_date
        errors.add(:end_date, 'は開始日より前の日を設定することはできません。')
      end
      if ((end_date.in_time_zone - start_date.in_time_zone) / 1.day).floor > 30
        errors.add(:date, 'は１ヶ月以内の期間を指定してください。')
      end
    end
  end
end