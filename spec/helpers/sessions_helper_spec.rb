require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe 'current_user' do
    let(:user) { FactoryBot.create(:user) }

    before do
      remember(user)
    end

    it '永続セッションでログインされるか' do
      aggregate_failures do
        expect(current_user).to eq user
        expect(logged_in?).to be_truthy
      end
    end

    it '永続セッションが異なる場合ログインされないか' do
      aggregate_failures do
        # 別のダイジェストに書き換えておく。
        user.update_attribute(:remember_digest, User.digest(User.new_token))
        # cookieに保存されたトークンとダイジェストが一致しないため、current_userはnilが返るべき
        expect(current_user).to eq nil
        expect(logged_in?).to be_falsy
      end
    end

  end
end