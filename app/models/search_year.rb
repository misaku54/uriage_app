class SearchYear
  include ActiveModel::Model

  attr_accessor :year

  validates :year, presence: true
end