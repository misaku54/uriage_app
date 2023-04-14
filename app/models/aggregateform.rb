class AggregateForm
  include ActiveModel::Model

  attr_accessor :month
  validates :month, presence: true
end