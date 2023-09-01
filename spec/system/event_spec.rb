require 'rails_helper'

RSpec.describe "カレンダー管理機能", type: :system do
  let!(:event) { FactoryBot.create(:event) }
  let(:user_a) { event.user }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }

  describe '未ログイン' do
    describe 'ページ遷移確認' do
      context 'カレンダーの新規登録画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit new_user_event_path(user_a)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
        end
      end

      context 'カレンダーの編集画面へアクセス' do
        it 'ログイン画面へ遷移し、フラッシュが表示されること' do
          visit edit_user_event_path(user_a, event)
          expect(page).to have_current_path login_path
          expect(page).to have_selector 'div.alert.alert-danger'
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

        context 'ユーザーAに紐づくカレンダーの新規登録画面へアクセス' do
          it '正常に遷移すること' do
            visit new_user_event_path(login_user)
            expect(page).to have_current_path new_user_event_path(login_user)
          end
        end

        context 'ユーザーAに紐づくカレンダーの編集画面へアクセス' do
          it '正常に遷移すること' do
            visit edit_user_event_path(login_user, event)
            expect(page).to have_current_path edit_user_event_path(login_user, event)
          end
        end
      end

      context 'ユーザーBでログインしている場合' do
        let(:login_user) { user_b }

        context 'ユーザーAに紐づくカレンダーの新規登録画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit new_user_event_path(user_a)
            expect(page).to have_current_path root_path
          end
        end

        context 'ユーザーAに紐づくカレンダーの編集画面へアクセス' do
          it 'ホーム画面へ遷移すること' do
            visit edit_user_event_path(user_a, event)
            expect(page).to have_current_path root_path
          end
        end
      end
    end

    describe '新規登録機能' do
      let(:login_user) { user_a }
      let!(:date) { Time.zone.now.strftime("%Y-%m-%d") }
      
      before do
        # ホーム画面へ遷移する
        visit root_path
        # カレンダーからイベントを登録したい日付をクリック
        find("a[href='/users/#{login_user.id}/events/new?default_date=#{date}']").click
      end

      context 'イベントを有効な値で登録した場合' do
        it '登録に成功する' do
          # 日付選択のセレクトボックスがデフォルトでクリックした日付になっていること
          expect(page).to have_select('event[start_time(1i)]', selected: date[0..3])
          expect(page).to have_select('event[start_time(2i)]', selected: date[5..6].to_i.to_s)
          expect(page).to have_select('event[start_time(3i)]', selected: date[8..9].to_i.to_s)
          expect(page).to have_select('event[start_time(4i)]', selected: '00')
          expect(page).to have_select('event[start_time(5i)]', selected: '00')
          fill_in 'event[title]', with: 'createイベント'
          # # DB上に登録されていること
          expect {
            click_button 'カレンダー登録'
          }.to change(Event, :count).by(1)
          # ホーム画面へ遷移していること
          expect(page).to have_current_path root_path
          # 成功時のフラッシュが表示されていること
          expect(page).to have_selector 'div.alert.alert-success'
          # 登録したイベントが表示されていること
          expect(page).to have_content 'createイベント'
        end
      end
      
      context 'イベントを無効な値で登録した場合' do
        it '登録に失敗する' do
          fill_in 'event[title]', with: ''
          # DB上に登録されていないこと
          expect {
            click_button 'カレンダー登録'
          }.to_not change(Event, :count)
          # エラーメッセージが表示されていること
          expect(page).to have_selector '#error_explanation'
        end
      end
    end


    describe '編集機能' do
      let(:login_user) { user_a }

      before do
        # ホーム画面へ遷移する
        visit root_path
        # カレンダーから編集したいイベントをクリック
        find("a[href='/users/#{login_user.id}/events/#{event.id}/edit']").click
      end

      context 'イベントを有効な値で更新した場合' do
        it '更新に成功する' do          
          fill_in 'event[title]', with: 'updateイベント'
          click_button 'カレンダー更新'

          # 正しい値に更新されているか
          event.reload
          expect(event.title).to eq 'updateイベント'
          # ホーム画面へ遷移していること
          expect(page).to have_current_path root_path
          # 成功時のフラッシュが表示されていること
          expect(page).to have_selector 'div.alert.alert-success'
          # 更新したメーカーが表示されていること
          expect(page).to have_content 'updateイベント'
        end
      end

      context 'イベントを無効な値で更新した場合' do
        it '更新に失敗する' do
          event_before = event
          fill_in 'event[title]', with: ''
          click_button 'カレンダー更新'
          event.reload
          # 更新前と値が変わっていないこと
          expect(event).to be event_before
          # エラーメッセージが表示されること
          expect(page).to have_selector '#error_explanation'
        end
      end
    end

    
    describe '削除機能' do
      let(:login_user) { user_a }

      context '一覧画面で削除ボタンをクリックした場合' do
        it '削除に成功する' do
          # ホーム画面へ遷移する
          visit root_path

          # DB上で削除されていること
          expect {
            find("button#delete-event#{event.id}").click
          }.to change(Event, :count).by(-1)
          # ホーム画面へ遷移していること
          expect(page).to have_current_path root_path
          # 削除したメーカーが表示されていないこと
          expect(page).to have_no_content 'イベント'
        end
      end
    end
  end
end