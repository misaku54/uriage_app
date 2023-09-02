require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'バリデーション' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:event) { user.events.build(title: 'イベント', start_time: Time.zone.now, end_time: Time.zone.now) }

    it 'eventが有効であること' do
      expect(event).to be_valid
    end

    it 'titleがなければ無効になること' do
      event.title = nil
      expect(event).to_not be_valid
    end
    
    it 'start_timeがなければ無効になること' do
      event.start_time = nil
      expect(event).to_not be_valid
    end
    
    it 'end_timeがなければ無効になること' do
      event.end_time = nil
      expect(event).to_not be_valid
    end

    it 'end_timeがstart_timeより前の日付であれば無効になること' do
      event.end_time = Time.zone.now.prev_month
      expect(event).to_not be_valid
    end
    
    it 'titleがが31文字以上は無効になること' do
      event.title = "a" * 31
      expect(event).to_not be_valid
    end

    it 'contentが1001文字以上は無効になること' do
      event.content = "a" * 1001
      expect(event).to_not be_valid
    end

    it 'user_idがなければ無効になること' do
      event.user_id = nil
      expect(event).to_not be_valid
    end

    it '紐づいているユーザーを削除すると、メーカーデータも削除されること' do
      event.save
      expect {
        user.destroy
      }.to change(Event, :count).by(-1)
    end
  end
end
