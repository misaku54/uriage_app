class Event < ApplicationRecord
  # 関連付け
  belongs_to :user

  # バリデーション
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 1000 }
  validates :start_time, presence: true 
  validates :end_time, presence: true 

  # カスタムバリデーション
  validate :check_time

  private

  def check_time
    return if self.start_time && self.end_time
    errors.add(:end_time, 'は開始時刻より前の日を設定することはできません。') if self.end_time < self.start_time
  end
end
