class Producttype < ApplicationRecord
  # 関連付け
  belongs_to :user
  has_many :sales, dependent: :nullify

  # バリデーション
  validates :name,  presence: true, length: { maximum:30 }
  # 一つのユーザーIDにつき、同じメーカー名は設定できない
  validates :name, uniqueness: { scope: :user_id } 

  def self.ransackable_attributes(auth_object = nil)
    ["name", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["sales", "user"]
  end
end
