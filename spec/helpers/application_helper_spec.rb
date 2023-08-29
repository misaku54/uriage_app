require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'full_title' do
    let(:base_title) { 'LiLy' }
    context '引数を渡した場合' do
      it '引数の文字列とベースタイトルが返ること' do
        expect(full_title('Page Title')).to eq "Page Title | #{base_title}"
      end
    end
    context '引数を渡さなかった場合' do
      it 'ベースタイトルのみ返ること' do
        expect(full_title()).to eq "#{base_title}"
      end
    end
  end

  describe 'add_comma_en' do
    context '引数を渡した場合' do
      let(:comma_en) { '10,000円' }
      it '渡した値のカンマ区切り円の文字列が返ること' do
        add_comma_en()
      end
    end

    context '引数を渡さなかった場合' do
      it '文字列0が返ってくること' do
        
      end
    end
  end

  describe 'add_comma' do
    context '引数を渡した場合' do
      let(:comma_en) { '10,000' }
      it '渡した値のカンマ区切りの文字列が返ること' do
        add_comma_en()
      end
    end

    context '引数を渡さなかった場合' do
      it '文字列0が返ってくること' do
        
      end
    end
  end
  
  describe 'add_ko_sold' do
    context '引数を渡した場合' do
      it '「個」を結合した文字列が返ること' do

      end
    end

    context '引数を渡さなかった場合' do
      it '0個が返ってくること' do

      end
    end
  end

  describe 'current_page_number' do
    context '引数で渡したオブジェクト群が最初のページの場合'
      it '正しいページ数を表示すること' do

      end
    end

    context '引数で渡したオブジェクト群が最初のページ以外の場合' do
      it '正しいページ数を表示すること' do
        
      end
    end

    context '引数を渡さなかった場合' do
      it '0件が返ってくること' do
        
      end
    end
  end

  describe 'get_holiday' do
    context '引数で渡した日付が祝日でない場合' do
      it '-を返すこと' do

      end
    end
    context '引数で渡した日付が祝日だった場合' do
      it '祝日の名前を返すこと' do

      end
    end
  end

  describe 'get_weather' do
    context '引数が空白の場合' do
      it '不明が返ること' do
        
      end
    end

    context '引数が0の場合' do
      it '快晴が返ること' do

      end
    end
    
    context '引数が1の場合' do
      it '晴れが返ること' do

      end
    end

    context '引数が2の場合' do
      it '一部曇が返ること' do

      end
    end
    
    context '引数が3の場合' do
      it '曇りが返ること' do

      end
    end
    
    context '引数が4以上49以下の場合' do
      it '霧が返ること' do

      end
    end
    
    context '引数が50以上59以下の場合' do
      it '霧雨が返ること' do

      end
    end
    
    context '引数が60以上69以下の場合' do
      it '雨が返ること' do

      end
    end
    
    context '引数が70以上79以下の場合' do
      it '雪が返ること' do

      end
    end
    
    context '引数が80以上84以下の場合' do
      it '俄か雨が返ること' do

      end
    end
    
    context '引数が85以上94以下の場合' do
      it '雪・雹が返ること' do

      end
    end
    
    context '引数が95以上99以下の場合' do
      it '雷雨が返ること' do

      end
    end
    
    context 'いずれにも当てはまらない時' do
      it '不明が返ること' do

      end
    end
  end
end