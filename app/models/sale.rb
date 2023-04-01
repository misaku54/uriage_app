class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :maker
  belongs_to :producttype
  # 複数項目にまとめてバリデーションする
  with_options presence: true do
    validates :user_id
    validates :maker_id
    validates :producttype_id
  end
end
