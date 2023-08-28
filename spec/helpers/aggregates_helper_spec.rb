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
        it '正しい文字列が返ること' do
          
        end
      end
      
      context 'makerの場合' do
        it '正しい文字列が返ること' do

        end
      end
      
      context 'producttypeの場合' do
        it '正しい文字列が返ること' do

        end
      end
    end

    context '引数が無効な値の場合' do
      context '条件外の値の場合' do
        it 'raiseすること' do

        end
      end
    end
  end
  
  describe 'make_color' do
    context '引数が有効な値の場合' do
      context 'maker_producttypeの場合' do
        it '正しい文字列が返ること' do
          
        end
      end
      
      context 'makerの場合' do
        it '正しい文字列が返ること' do

        end
      end
      
      context 'producttypeの場合' do
        it '正しい文字列が返ること' do

        end
      end
    end

    context '引数が無効な値の場合' do
      context '条件外の値の場合' do
        it 'raiseすること' do

        end
      end
    end
  end
end
