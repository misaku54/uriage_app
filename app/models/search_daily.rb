# 日別集計用フォームクラス
class SearchDaily
  include ActiveModel::Model
  VALID_DATE_REGEX = /\A\d{4}-\d{2}-\d{2}/

  # アクセサメソッド
  attr_accessor :start_date, :end_date

  # バリデーション
  validates :start_date,  presence: true,
                          format: { with: VALID_DATE_REGEX, allow_blank: true }
  validates :end_date,    presence: true,
                          format: { with: VALID_DATE_REGEX, allow_blank: true }
  
  # カスタムバリデーション
  validate :date_check # 開始日と終了日のチェック

  private

  def date_check
    if self.start_date.present? && self.end_date.present?
      if self.end_date.in_time_zone < self.start_date.in_time_zone
        errors.add(:end_date, 'は開始日より前の日を設定することはできません。')
      end

      if ((self.end_date.in_time_zone - self.start_date.in_time_zone) / 1.day).floor > 30
        errors.add(:date, 'は１ヶ月以内の期間を指定してください。')
      end
    end
  end
end