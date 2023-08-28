require 'rails_helper'

RSpec.describe AggregatesHelper, type: :helper do
  let!(:user) { FactoryBot.create(:user) }
  let!(:producttype) { FactoryBot.create(:producttype, user: user) }
  let!(:maker) { FactoryBot.create(:maker, user: user) }
  let!(:weather) { FactoryBot.create(:weather) }
  let!(:sale) { FactoryBot.create(:sale, user: user, maker: maker, producttype: producttype)}
  let!(:start_date) { Time.zone.now.beginning_of_day }
  let!(:end_date) { Time.zone.now.end_of_day }
  let!(:last_year_start_date) { Time.zone.now.prev_year.beginning_of_day }
  let!(:last_year_end_date) { Time.zone.now.prev_year.end_of_day }
  
  describe 'convert_array' do
    before do
      aggregate = Aggregate.new(start_date: start_date, end_date: end_date, last_year_start_date: last_year_start_date, last_year_end_date: last_year_end_date, user: user, type: 'day')
      aggregate.call
      @aggregates_of_maker_producttype = aggregate.aggregates_of_maker_producttype
      @aggregates_of_maker             = aggregate.aggregates_of_maker
      @aggregates_of_producttype       = aggregate.aggregates_of_producttype
    end

    context '引数が有効な値の場合' do
      context '第二引数がmaker_producttypeの場合' do
        let(:ary) { [["テスト会社 カバン", 10000]] }
        it '配列が作成されること' do
          expect(convert_array(@aggregates_of_maker_producttype, 'maker_producttype')).to eq ary
        end
      end

      context '第二引数がmakerの場合' do
        let(:ary) { [["テスト会社", 10000]] }
        it '配列が作成されること' do
          expect(convert_array(@aggregates_of_maker, 'maker')).to eq ary
        end
      end

      context '第二引数がproducttypeの場合' do
        let(:ary) { [["カバン", 10000]] }
        it '配列が作成されること' do
          expect(convert_array(@aggregates_of_producttype, 'producttype')).to eq ary
        end
      end
    end

    context '引数が無効な値の場合' do
      context '第二引数が条件外の値の場合' do
        it 'raiseすること' do
          expect{convert_array(@aggregates_of_producttype, 'foo')}.to raise_error(ArgumentError, '無効な引数が渡されました。pattern: foo')
        end
      end
    end
  end

  describe 'make_title' do
    context '引数が有効な値の場合' do
      context 'maker_producttypeの場合' do
        let(:title) { 'メーカー×商品分類' }
        it '正しい文字列が返ること' do
          expect(make_title('maker_producttype')).to eq title
        end
      end
      
      context 'makerの場合' do
        let(:title) { 'メーカー' }
        it '正しい文字列が返ること' do
          expect(make_title('maker')).to eq title
        end
      end
      
      context 'producttypeの場合' do
        let(:title) { '商品分類' }
        it '正しい文字列が返ること' do
          expect(make_title('producttype')).to eq title
        end
      end
    end

    context '引数が無効な値の場合' do
      context '条件外の値の場合' do
        it 'raiseすること' do
          expect{ make_title('foo') }.to raise_error(ArgumentError, '無効な引数が渡されました。pattern: foo')
        end
      end
    end
  end

  describe 'make_color' do
    context '引数が有効な値の場合' do
      context 'maker_producttypeの場合' do
        let(:color) { '#003793' }
        it '正しい文字列が返ること' do
          expect(make_color('maker_producttype')).to eq color
        end
      end
      
      context 'makerの場合' do
        let(:color) { '#69AADE' }
        it '正しい文字列が返ること' do
          expect(make_color('maker')).to eq color
        end
      end
      
      context 'producttypeの場合' do
        let(:color) { '#009E96' }
        it '正しい文字列が返ること' do
          expect(make_color('producttype')).to eq color
        end
      end
    end

    context '引数が無効な値の場合' do
      context '条件外の値の場合' do
        it 'raiseすること' do
          expect{ make_color('foo') }.to raise_error(ArgumentError, '無効な引数が渡されました。pattern: foo')
        end
      end
    end
  end

  describe 'best_selling_name' do
    before do
      aggregate = Aggregate.new(start_date: start_date, end_date: end_date, last_year_start_date: last_year_start_date, last_year_end_date: last_year_end_date, user: user, type: 'day')
      aggregate.call
      @aggregates_of_maker_producttype = aggregate.aggregates_of_maker_producttype
      @aggregates_of_maker             = aggregate.aggregates_of_maker
      @aggregates_of_producttype       = aggregate.aggregates_of_producttype
    end

    context '引数が有効な値の場合' do
      context 'メーカー×商品分類のオブジェクトの場合' do
        let(:name) { 'テスト会社のカバン' }
        it '正しい文字列が返ること' do
          expect(best_selling_name(@aggregates_of_maker_producttype.first)).to eq name
        end
      end
      context 'メーカーのオブジェクトの場合' do
        let(:name) { 'テスト会社' }
        it '正しい文字列が返ること' do
          expect(best_selling_name(@aggregates_of_maker.first)).to eq name
        end
      end
      context '商品分類のオブジェクトの場合' do
        let(:name) { 'カバン' }
        it '正しい文字列が返ること' do
          expect(best_selling_name(@aggregates_of_producttype.first)).to eq name
        end
      end
    end
    context '引数が無効な値の場合' do
      context 'nilの場合' do
        it 'raiseすること' do
          expect{best_selling_name(nil)}.to raise_error(ArgumentError,"無効な引数が渡されました。aggregate:")
        end
      end
    end
  end
end
