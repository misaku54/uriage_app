class Maker < ApplicationRecord
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

  def self.csv_output(makers)
    CSV.generate do |csv|
      csv << ["メーカー名","登録日"]
      makers.each do |maker|
        csv << [maker.name, maker.created_at.strftime("%Y/%m/%d %H:%M")]
      end
    end
  end
end
