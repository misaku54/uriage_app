require 'rails_helper'

RSpec.describe Sale, type: :model do
  describe 'バリデーション' do
    let!(:sale) { FactoryBot.create(:sale) }
    let(:other_user) { FactoryBot.create(:user, name: '他のユーザー', email: 'other@example.com') } 
    let!(:other_maker) { FactoryBot.create(:maker, name: '他のユーザーが登録したメーカー', user: other_user) }
    let!(:other_producttype) { FactoryBot.create(:producttype, name:'他のユーザーが登録した商品', user: other_user) }

    it 'saleが有効であること' do
      expect(sale).to be_valid
    end

    it 'amount_soldがなければ無効になること' do
      sale.amount_sold = nil
      expect(sale).to_not be_valid
    end

    it 'amount_soldが0なら無効になること' do
      sale.amount_sold = 0
      expect(sale).to_not be_valid
    end

    it 'amount_soldが数値以外なら無効になること' do
      sale.amount_sold = '数値以外'
      expect(sale).to_not be_valid
    end

    it 'remarkがなくても有効であること' do
      sale.remark = nil
      expect(sale).to be_valid
    end

    it 'remarkが1000文字以上は無効になること' do
      sale.remark = 'a' * 1001
      expect(sale).to_not be_valid
    end 

    it 'maker_idがなければ無効になること' do
      sale.maker_id = nil
      expect(sale).to_not be_valid
    end

    it '他のユーザーが登録しているmaker_idは無効になること' do
      sale.maker_id = other_maker.id
      expect(sale).to_not be_valid
    end

    it 'producttype_idがなければ無効になること' do
      sale.producttype_id = nil
      expect(sale).to_not be_valid
    end

    it '他のユーザーが登録しているproducttype_idは無効になること' do
      sale.producttype_id = other_producttype.id
      expect(sale).to_not be_valid
    end

    it 'user_idがなければ無効になること' do
      sale.user_id = nil
      expect(sale).to_not be_valid
    end
  end
end
