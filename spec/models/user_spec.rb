require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe 'バリデーション' do
    let(:user) { FactoryBot.build(:user) }

    it 'userが有効であること' do
      expect(user).to be_valid
    end
    
    it 'nameがなければ無効になること' do
      user.name  = nil
      expect(user).to_not be_valid
    end
    
    it 'emailがなければ無効になること' do
      user.email = nil
      expect(user).to_not be_valid
    end
    
    it 'nameが51文字以上は無効になること' do
      user.name  = "a" * 51
      expect(user).to_not be_valid
    end
    
    it 'emailが256文字以上は無効になること' do
      user.email = "a" * 244 + "@example.com"
      expect(user).to_not be_valid
    end
    
    it '無効なemailは無効になること' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to_not be_valid
      end
    end

    it 'emailは重複して登録できないこと' do
      user.save
      duplicate_user = user.dup
      duplicate_user.email.upcase!
      expect(duplicate_user).to_not be_valid
    end
  end
end