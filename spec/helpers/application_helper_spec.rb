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
    
  end
end