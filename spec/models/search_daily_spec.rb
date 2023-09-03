require 'rails_helper'

RSpec.describe SearchDaily, type: :model do
  describe 'バリデーション' do
    let!(:search_params) { SearchDaily.new(start_date: "2023-08-01", end_date: "2023-08-05") }

    it 'search_paramsが有効であること' do
      expect(search_params).to be_valid
    end

    it 'start_dateがなければ無効になること' do
      search_params.start_date = nil
      expect(search_params).to_not be_valid
    end

    it 'end_dateがなければ無効になること' do
      search_params.end_date = nil
      expect(search_params).to_not be_valid
    end

    it 'start_dateのフォーマットがyyyy-mm-dd以外なら無効になること' do
      search_params.start_date = '02023-008-001'
      expect(search_params).to_not be_valid
    end

    it 'end_dateのフォーマットがyyyy-mm-dd以外なら無効になること' do
      search_params.end_date = '02023-008-005'
      expect(search_params).to_not be_valid
    end

    it 'end_date < start_dateなら無効になること' do
      search_params.end_date = "2023-07-01"
      expect(search_params).to_not be_valid
    end

    it 'start_dateとend_dateの期間が一ヶ月以上なら無効になること' do
      search_params.end_date = "2023-09-01"
      expect(search_params).to_not be_valid
    end
  end
end