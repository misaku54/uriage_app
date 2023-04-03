class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :maker
  belongs_to :producttype
  # 販売価格は数値のみで1円以上
  validates :amount_sold, numericality: { greater_than_or_equal_to: 1 }
  # 備考は1000文字まで
  validates :remark, length: { maximum: 1000 }
end
