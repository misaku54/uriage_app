require 'rails_helper'

RSpec.describe "スケジュール管理機能", type: :system do
  let!(:event) { FactoryBot.create(:event) }
  let(:user) { event.user }

  describe '未ログイン' do
    describe 'ページ遷移確認' do
      context 'スケジュールの新規登録画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit new_user_event_path(user)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context 'スケジュールの編集画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit edit_user_event_path(user, event)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end
    end
  end
end