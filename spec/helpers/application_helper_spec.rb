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
        expect(full_title).to eq "#{base_title}"
      end
    end
  end

  describe 'add_comma_en' do
    context '引数を渡した場合' do
      it '渡した値のカンマ区切り円の文字列が返ること' do
        expect(add_comma_en(10_000)).to eq '10,000円'
      end
    end

    context '引数を渡さなかった場合' do
      it '0円が返ってくること' do
        expect(add_comma_en).to eq '0円'
      end
    end
  end

  describe 'add_comma' do
    context '引数を渡した場合' do
      it '渡した値のカンマ区切りの文字列が返ること' do
        expect(add_comma(10_000)).to eq '10,000'
      end
    end

    context '引数を渡さなかった場合' do
      it '文字列0が返ってくること' do
        expect(add_comma).to eq '0'
      end
    end
  end

  describe 'add_ko_sold' do
    context '引数を渡した場合' do
      it '「個」を結合した文字列が返ること' do
        expect(add_ko_sold(10_000)).to eq '10000個'
      end
    end

    context '引数を渡さなかった場合' do
      it '0個が返ってくること' do
        expect(add_ko_sold).to eq '0個'
      end
    end
  end

  describe 'current_page_number' do
    let!(:users) { FactoryBot.create_list(:user, 15, :users) }
    context '渡した引数がkaminariの1ページ目のオブジェクトの場合' do
      let(:first_page_obj) { User.page(1).per(10) }
      it '正しいページ数を表示すること' do
        expect(current_page_number(first_page_obj)).to eq '10/15件'
      end
    end

    context '引数で渡したオブジェクト群が最初のページ以外の場合' do
      let(:not_first_page_obj) { User.page(2).per(10) }
      it '正しいページ数を表示すること' do
        expect(current_page_number(not_first_page_obj)).to eq '15/15件'
      end
    end

    context '引数が空ornilだった場合' do
      it '0件が返ってくること' do
        expect(current_page_number(nil)).to eq '0件'
        expect(current_page_number('')).to eq '0件'
      end
    end
  end

  describe 'get_holiday' do
    context '引数で渡した日付が祝日だった場合' do
      let(:date) { Time.zone.parse('2023-7-17') }
      it '祝日の名前を返すこと' do
        expect(get_holiday(date)).to eq '海の日'
      end
    end

    context '引数で渡した日付が祝日でない場合' do
      let(:date) { Time.zone.parse('2023-7-16') }
      it '-を返すこと' do
        expect(get_holiday(date)).to eq '-'
      end
    end
  end

  describe 'get_weather' do
    context '引数が空白の場合' do
      let(:weather_code) { nil }
      it '不明が返ること' do
        expect(get_weather(weather_code)).to eq '不明'
      end
    end

    context '引数が0の場合' do
      let(:weather_code) { 0 }
      it '快晴が返ること' do
        expect(get_weather(weather_code)).to eq "快晴\u{2600}"
      end
    end

    context '引数が1の場合' do
      let(:weather_code) { 1 }
      it '晴れが返ること' do
        expect(get_weather(weather_code)).to eq "晴れ\u{2600}"
      end
    end

    context '引数が2の場合' do
      let(:weather_code) { 2 }
      it '一部曇が返ること' do
        expect(get_weather(weather_code)).to eq "一部曇\u{1F324}"
      end
    end

    context '引数が3の場合' do
      let(:weather_code) { 3 }
      it '曇りが返ること' do
        expect(get_weather(weather_code)).to eq "曇り\u{2601}"
      end
    end

    context '引数が4以上49以下の場合' do
      let(:weather_code_min) { 4 }
      let(:weather_code_max) { 49 }
      it '霧が返ること' do
        expect(get_weather(weather_code_min)).to eq "霧\u{1F32B}"
        expect(get_weather(weather_code_max)).to eq "霧\u{1F32B}"
      end
    end

    context '引数が50以上59以下の場合' do
      let(:weather_code_min) { 50 }
      let(:weather_code_max) { 59 }
      it '霧雨が返ること' do
        expect(get_weather(weather_code_min)).to eq "霧雨\u{1F32B}"
        expect(get_weather(weather_code_max)).to eq "霧雨\u{1F32B}"
      end
    end

    context '引数が60以上69以下の場合' do
      let(:weather_code_min) { 60 }
      let(:weather_code_max) { 69 }
      it '雨が返ること' do
        expect(get_weather(weather_code_min)).to eq "雨\u{1F327}"
        expect(get_weather(weather_code_max)).to eq "雨\u{1F327}"
      end
    end

    context '引数が70以上79以下の場合' do
      let(:weather_code_min) { 70 }
      let(:weather_code_max) { 79 }
      it '雪が返ること' do
        expect(get_weather(weather_code_min)).to eq "雪\u{26C4}"
        expect(get_weather(weather_code_max)).to eq "雪\u{26C4}"
      end
    end

    context '引数が80以上84以下の場合' do
      let(:weather_code_min) { 80 }
      let(:weather_code_max) { 84 }
      it '俄か雨が返ること' do
        expect(get_weather(weather_code_min)).to eq "俄か雨\u{1F327}"
        expect(get_weather(weather_code_max)).to eq "俄か雨\u{1F327}"
      end
    end

    context '引数が85以上94以下の場合' do
      let(:weather_code_min) { 85 }
      let(:weather_code_max) { 94 }
      it '雪・雹が返ること' do
        expect(get_weather(weather_code_min)).to eq "雪・雹\u{2603}"
        expect(get_weather(weather_code_max)).to eq "雪・雹\u{2603}"
      end
    end

    context '引数が95以上99以下の場合' do
      let(:weather_code_min) { 95 }
      let(:weather_code_max) { 99 }
      it '雷雨が返ること' do
        expect(get_weather(weather_code_min)).to eq "雷雨\u{26C8}"
        expect(get_weather(weather_code_max)).to eq "雷雨\u{26C8}"
      end
    end

    context 'いずれにも当てはまらない時' do
      let(:not_weather_code) { 100 }
      it '不明が返ること' do
        expect(get_weather(not_weather_code)).to eq '不明'
      end
    end
  end
end
