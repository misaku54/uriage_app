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

  def self.csv_output(producttypes)
    CSV.generate do |csv|
      csv << ["商品分類名","登録日時"]
      producttypes.each do |producttype|
        csv << [producttype.name, producttype.created_at]
      end
    end
  end
end
