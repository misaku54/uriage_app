require 'rails_helper'

RSpec.describe "メーカー管理機能", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe '一覧表示機能' do
    before do
      maker = FactoryBot.create(:maker)
      visit login_path
      fill_in 'メールアドレス', with: maker.user.email
      fill_in 'パスワード', with: maker.user.password
      click_button 'ログイン'
    end

    # it '' do
    # end
  end

end
