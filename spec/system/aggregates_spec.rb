require 'rails_helper'

RSpec.describe "集計機能", type: :system do

  describe '未ログイン' do
    context '年次集計画面へアクセス' do
      it 'ログイン画面へ遷移し、フラッシュが表示されること' do
        
      end
    end

    context '月次集計画面へアクセス' do
      it 'ログイン画面へ遷移し、フラッシュが表示されること' do

      end
    end

    context '日次集計画面へアクセス' do
      it 'ログイン画面へ遷移し、フラッシュが表示されること' do
        
      end
    end
  end

  describe 'ログイン中' do
    before do
      log_in(login_user)
    end

    describe '年次集計機能' do
      
    end
    
    describe '月次集計機能' do
      
    end

    describe '日次集計機能' do
      
    end
  end
end