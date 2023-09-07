class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # アクセサメソッド
  attr_accessor :remember_token

  # 関連付け
  has_many :makers, dependent: :destroy
  has_many :producttypes, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :events, dependent: :destroy
  
  # save時にメールアドレスは小文字で登録
  before_save { email.downcase! }

  # バリデーション
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format:   { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # ransackの設定
  def self.ransackable_attributes(auth_object = nil)
    ["admin", "created_at", "email", "id", "name", "password_digest", "remember_digest", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["makers", "producttypes", "sales"]
  end
  
  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続的セッションのためユーザーをデータベースに記憶する。
  def remember
    # 代入する時はselfが必要、参照する際はいらない。
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # セッションハイジャック防止のためにセッショントークンを返す
  # この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 受け取った日付の就業時間内の1時間ごとの売上合計額の取得
  def hourly_sales_sum(date)
    today_9_hour  = Time.zone.local(date.year, date.month, date.day, 9)
    today_21_hour = Time.zone.local(date.year, date.month, date.day, 21)
    self.sales.group_by_hour(:created_at, range: today_9_hour..today_21_hour).sum(:amount_sold)
  end

  # 受け取った日付の売上合計額の取得
  def sales_sum(date)
    self.sales.where(created_at: date.all_day).sum(:amount_sold)
  end
end
