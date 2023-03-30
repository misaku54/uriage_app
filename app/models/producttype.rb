class Producttype < ApplicationRecord
  belongs_to :user
  validates :name,  presence: true, length: { maximum:30 }
  validates :user_id, presence: true
end
