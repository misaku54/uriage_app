require 'rails_helper'

RSpec.describe SearchForm, type: :model do
  describe 'バリデーション' do
    let(:params) { ActionController::Parameters.new({"date(1i)"=>"2023", "date(2i)"=>"9", "date(3i)"=>"1"}) }
    let!(:search_params) { SearchForm.new(params.permit(:date)) }

    it 'search_paramsが有効であること' do
      expect(search_params).to be_valid
    end
    
    it 'dateが空白のなら無効であること' do
      search_params.date = nil
      expect(search_params).to_not be_valid
    end
  end
end