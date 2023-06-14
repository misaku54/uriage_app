require 'rails_helper'

RSpec.describe "集計機能", type: :system do

  describe '未ログイン' do
    describe 'ページ遷移確認' do
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
  end

  describe 'ログイン中' do
    before do
      log_in(login_user)
    end

    describe 'ページ遷移確認' do
      context 'ユーザーAでログインしている場合' do
        let(:login_user) { user_a }

        context 'ユーザーAに紐づく年次集計画面へアクセス' 
          it '正常に遷移すること' do
            
          end
        end

        context 'ユーザーAに紐づく月次集計画面へアクセス' 
          it '正常に遷移すること' do
            
          end
        end
        
        context 'ユーザーAに紐づく日次集計画面へアクセス' 
          it '正常に遷移すること' do
            
          end
        end
      end

      context 'ユーザーBでログインしている場合' do
        let(:login_user) { user_b }
        
        context 'ユーザーAに紐づく年次集計画面へアクセス' 
          it 'ホーム画面へ遷移すること' do
            
          end
        end

        context 'ユーザーAに紐づく月次集計画面へアクセス' 
          it 'ホーム画面へ遷移すること' do
            
          end
        end
        
        context 'ユーザーAに紐づく日次集計画面へアクセス' 
          it 'ホーム画面へ遷移すること' do
            
          end
        end
      end
    end
    
    describe '年次集計機能' do
      
    end
    
    describe '月次集計機能' do
      
    end

    describe '日次集計機能' do
      
    end
  end
end