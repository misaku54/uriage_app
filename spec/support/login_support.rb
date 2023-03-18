module LoginSupport
  # 名前空間を利用し、ログインヘルパーをテストの種類で使い分ける
  module System
    def log_in(user)
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end
  end

  module Request
    # ログインする
    def log_in(user)
      post login_path, params: { session: { email: user.email,
                                            password: user.password } }
    end
    
    # ログインしているか確認
    def logged_in?
      !session[:user_id].nil?
    end
  end
end