class Producttype < ApplicationRecord
  belongs_to :user
  has_many :sales, dependent: :nullify
  validates :name,  presence: true, length: { maximum:30 }
  validates :user_id, presence: true
  # 一つのユーザーIDにつき、同じメーカー名は設定できない
  validates :name, uniqueness: { scope: :user_id } 
end
