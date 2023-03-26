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

    it 'user_idがなければ無効になること' do
      maker.user_id = nil
      expect(maker).to_not be_valid
    end
  end
end
