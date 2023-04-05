class Sale < ApplicationRecord
  include SessionsHelper
  belongs_to :user
  belongs_to :maker
  belongs_to :producttype
  # 販売価格は数値のみで1円以上
  validates :amount_sold, numericality: { greater_than_or_equal_to: 1 }
  # 備考は1000文字まで
  validates :remark, length: { maximum: 1000 }

  # 登録していないメーカー名や商品名で更新できない
  validate :maker_id_should_be_registered
  validate :producttype_id_should_be_registered

  private 

  def maker_id_should_be_registered
    select_maker = Maker.find_by(id: maker_id, user_id: user_id)
    errors.add(:maker_id, 'の値が不正です') unless select_maker
  end

  def producttype_id_should_be_registered
    select_producttype = Producttype.find_by(id: producttype_id, user_id: user_id)
    errors.add(:producttype_id, 'の値が不正です') unless select_producttype
  end
end
