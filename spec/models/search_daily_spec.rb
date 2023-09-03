require 'rails_helper'

RSpec.describe SearchDaily, type: :model do
  describe 'バリデーション' do
    let!(:search_daily) { SearchDaily.new(start_date: "2023-08-01", end_date: "2023-08-05") }

    it 'search_dailyが有効であること' do
      expect(search_daily).to be_valid
    end

    it 'start_dateがなければ無効になること' do
      search_daily.start_date = nil
      expect(search_daily).to_not be_valid
    end

    it 'end_dateがなければ無効になること' do
      search_daily.end_date = nil
      expect(search_daily).to_not be_valid
    end

    it 'start_dateのフォーマットがyyyy-mm-dd以外なら無効になること' do
      search_daily.start_date = '02023-008-001'
      expect(search_daily).to_not be_valid
    end

    it 'end_dateのフォーマットがyyyy-mm-dd以外なら無効になること' do
      search_daily.end_date = '02023-008-005'
      expect(search_daily).to_not be_valid
    end

    it 'end_date < start_dateなら無効になること' do
      search_daily.end_date = "2023-07-01"
      expect(search_daily).to_not be_valid
    end

    it 'start_dateとend_dateの期間が一ヶ月以上なら無効になること' do
      search_daily.end_date = "2023-09-01"
      expect(search_daily).to_not be_valid
    end
  end
end