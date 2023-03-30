require 'rails_helper'

RSpec.describe Maker, type: :model do
  describe 'バリデーション' do
    let(:user) { FactoryBot.create(:user) }
    let(:maker) { user.makers.build(name: 'テスト会社' ) }

    it 'makerが有効であること' do
      expect(maker).to be_valid
    end

    it 'nameがなければ無効になること' do
      maker.name = nil
      expect(maker).to_not be_valid
    end

    it 'nameが31文字以上は無効になること' do
      maker.name = "a" * 31
      expect(maker).to_not be_valid
    end

    it '1ユーザーにつき、同じnameは設定できない' do
      duplicate_maker = maker.dup
      maker.save
      expect(duplicate_maker).to_not be_valid
    end

    it 'user_idがなければ無効になること' do
      maker.user_id = nil
      expect(maker).to_not be_valid
    end

    it '紐づいているユーザーを削除すると、メーカーデータも削除されること' do
      maker.save
      expect {
        user.destroy
      }.to change(Maker, :count).by(-1)
    end
  end
end
