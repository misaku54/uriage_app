class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :maker
  belongs_to :producttype
end
