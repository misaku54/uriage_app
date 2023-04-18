class SearchDaily
  include ActiveModel::Model

  attr_accessor :start_date, :end_date

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :date_check

  private

  def date_check
    if end_date < start_date
      errors.add(:end_date, 'は開始日より前の日を設定することはできません。')
    end
  end
end