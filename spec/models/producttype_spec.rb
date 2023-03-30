require 'rails_helper'

RSpec.describe Producttype, type: :model do
  describe 'バリデーション' do
    let(:user) { FactoryBot.create(:user) }
    let(:producttype) { user.producttypes.build(name: 'カバン' ) }

    it 'producttypeが有効であること' do
      expect(producttype).to be_valid
    end

    it 'nameがなければ無効になること' do
      producttype.name = nil
      expect(producttype).to_not be_valid
    end

    it 'nameが31文字以上は無効になること' do
      producttype.name = "a" * 31
      expect(producttype).to_not be_valid
    end

    it 'user_idがなければ無効になること' do
      producttype.user_id = nil
      expect(producttype).to_not be_valid
    end

    it '紐づいているユーザーを削除すると、商品データも削除されること' do
      producttype.save
      expect {
        user.destroy
      }.to change(Producttype, :count).by(-1)
    end
  end
end
