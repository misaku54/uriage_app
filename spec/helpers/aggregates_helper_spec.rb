require 'rails_helper'

RSpec.describe AggregatesHelper, type: :helper do
  describe 'convert_array' do
    context '引数が有効な値の場合' do
      context '第二引数がmaker_producttypeの場合' do
        it '配列が作成されること' do
          
        end
      end

      context '第二引数がmakerの場合' do
        it '配列が作成されること' do

        end
      end

      context '第二引数がproducttypeの場合' do
        it '配列が作成されること' do

        end
      end
    end

    context '引数が無効な値の場合' do
      context '第一引数がnilの場合' do
        it 'raiseすること' do

        end
      end

      context '第二引数が条件外の値の場合' do
        it 'raiseすること' do
        
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
end
