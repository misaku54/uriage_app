class Sale < ApplicationRecord
  include SessionsHelper
  # created_onのデフォルト値に現在の日付を設定 
  # attribute :created_on, default: -> { Time.zone.local(2021,1,1) }

  # 関連付け
  belongs_to :user
  belongs_to :maker
  belongs_to :producttype
  belongs_to :weather, class_name: 'WeatherForecast', foreign_key: 'created_on', optional: true

  # アクションコールバック
  before_validation :set_created_on

  # バリデーション
  validates :amount_sold, presence: true
  validates :amount_sold, numericality: { greater_than_or_equal_to: 1 }, allow_nil: true #売上登録できる販売額は１円以上でなければならない。
  validates :remark, length: { maximum: 1000 }
  validates :created_at, presence: true
  validate :maker_id_should_be_registered       #売上登録できるメーカー名は、メーカーマスタに登録されているものでなければならない
  validate :producttype_id_should_be_registered #売上登録できる商品分類名は、商品分類マスタに登録されているものでなければならない
  # validate :aquired_on_should_be_registered # 売上登録できる登録日付は、天気予報DBに登録されているものでなければならない

  # scopeで使う集計用SQL（できればサービスモデルに持っていきたい。）
  sql_1 = <<-EOS
  SELECT COALESCE(k.maker_name, '未登録') maker_name, COALESCE(k.producttype_name, '未登録') producttype_name, k.sum_amount_sold, k.quantity_sold,
  COALESCE(z.sum_amount_sold, 0) last_year_sum_amount_sold, COALESCE(z.quantity_sold, 0) last_year_quantity_sold,
  CASE WHEN COALESCE(z.sum_amount_sold, 0) > 0 THEN CONCAT(TRUNCATE((k.sum_amount_sold - COALESCE(z.sum_amount_sold, 0)) / COALESCE(z.sum_amount_sold, 0) * 100, 1),'%') ELSE '-' END sales_growth_rate
    FROM (SELECT s.maker_id, m.name maker_name, s.producttype_id, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      LEFT JOIN makers m 
      ON m.id = s.maker_id
      LEFT JOIN producttypes p 
      ON p.id = s.producttype_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :start_date AND :end_date
      GROUP BY maker_id, producttype_id) k
    LEFT JOIN (SELECT s.maker_id, m.name maker_name, s.producttype_id, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      LEFT JOIN makers m 
      ON m.id = s.maker_id
      LEFT JOIN producttypes p 
      ON p.id = s.producttype_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :last_year_start_date AND :last_year_end_date
      GROUP BY maker_id, producttype_id) z
    ON k.maker_id = z.maker_id AND k.producttype_id = z.producttype_id
    ORDER BY k.sum_amount_sold DESC
  EOS

  sql_2 = <<-EOS
  SELECT COALESCE(k.maker_name,'未登録') maker_name, k.sum_amount_sold, k.quantity_sold,
  COALESCE(z.sum_amount_sold, 0) last_year_sum_amount_sold, COALESCE(z.quantity_sold, 0) last_year_quantity_sold,
  CASE WHEN COALESCE(z.sum_amount_sold, 0) > 0 THEN CONCAT(TRUNCATE((k.sum_amount_sold - COALESCE(z.sum_amount_sold, 0)) / COALESCE(z.sum_amount_sold, 0) * 100, 1),'%') ELSE '-' END sales_growth_rate
    FROM (SELECT s.maker_id, m.name maker_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      LEFT JOIN makers m 
      ON m.id = s.maker_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :start_date AND :end_date
      GROUP BY maker_id) k
    LEFT JOIN (SELECT s.maker_id, m.name maker_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      LEFT JOIN makers m 
      ON m.id = s.maker_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :last_year_start_date AND :last_year_end_date
      GROUP BY maker_id) z
    ON k.maker_id = z.maker_id
    ORDER BY k.sum_amount_sold DESC
  EOS

  sql_3 = <<-EOS
  SELECT COALESCE(k.producttype_name,'未登録') producttype_name, k.sum_amount_sold, k.quantity_sold,
  COALESCE(z.sum_amount_sold, 0) last_year_sum_amount_sold, COALESCE(z.quantity_sold, 0) last_year_quantity_sold,
  CASE WHEN COALESCE(z.sum_amount_sold, 0) > 0 THEN CONCAT(TRUNCATE((k.sum_amount_sold - COALESCE(z.sum_amount_sold, 0)) / COALESCE(z.sum_amount_sold, 0) * 100, 1),'%') ELSE '-' END sales_growth_rate
    FROM (SELECT s.producttype_id, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      LEFT JOIN producttypes p 
      ON p.id = s.producttype_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :start_date AND :end_date
      GROUP BY producttype_id) k
    LEFT JOIN (SELECT s.producttype_id, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      LEFT JOIN producttypes p 
      ON p.id = s.producttype_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :last_year_start_date AND :last_year_end_date
      GROUP BY producttype_id) z
    ON k.producttype_id = z.producttype_id
    ORDER BY k.sum_amount_sold DESC
  EOS

  # スコープ
  # メーカー、商品別の合計販売額と合計販売数を集計する。
  scope :maker_id_and_producttype_id_each_total_sales, -> (user, start_date, end_date, last_year_start_date, last_year_end_date) { find_by_sql([sql_1,{ user_id: user.id,
                                                                                                    start_date: start_date,
                                                                                                    end_date: end_date,
                                                                                                    last_year_start_date: last_year_start_date,
                                                                                                    last_year_end_date: last_year_end_date }]) }
  # メーカー別の合計販売額と合計販売数を集計する。
  scope :maker_id_each_total_sales,                    -> (user, start_date, end_date, last_year_start_date, last_year_end_date) { find_by_sql([sql_2,{ user_id: user.id,
                                                                                                    start_date: start_date,
                                                                                                    end_date: end_date,
                                                                                                    last_year_start_date: last_year_start_date,
                                                                                                    last_year_end_date: last_year_end_date }]) }
  # 商品別の合計販売額と合計販売数を集計する。
  scope :producttype_id_each_total_sales,              -> (user, start_date, end_date, last_year_start_date, last_year_end_date) { find_by_sql([sql_3,{ user_id: user.id,
                                                                                                    start_date: start_date,
                                                                                                    end_date: end_date,
                                                                                                    last_year_start_date: last_year_start_date,
                                                                                                    last_year_end_date: last_year_end_date }]) }

  # 売上成長率を計算する。
  def self.sales_growth_rate(sales_total_amount = 0, last_year_sales_total_amount = 0)
    if last_year_sales_total_amount > 0
      # 売上成長率 = (今年売上 - 前年売上) ÷ 前年売上 × 100　
      "#{((sales_total_amount - last_year_sales_total_amount) / last_year_sales_total_amount.to_f * 100).floor(1)}%"
    else
      "-"
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "maker_id", "producttype_id", "amount_sold", "remark"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["maker", "producttype"]
  end

  private 

  def maker_id_should_be_registered
    # カスタムバリデーションでallow_nilがやりたかった。
    return if self.maker_id.blank?
    errors.add(:maker_id, 'はマスターに登録されていない値です') unless Maker.find_by(id: maker_id, user_id: user_id)
  end

  def producttype_id_should_be_registered
    return if self.producttype_id.blank?
    errors.add(:producttype_id, 'はマスターに登録されていない値です') unless Producttype.find_by(id: producttype_id, user_id: user_id)
  end

  def aquired_on_should_be_registered
    return if self.created_at.blank?
    errors.add(:created_at, 'は天気DBに登録されていない値です。未来日か運用開始日より前の日付の可能性があります。') unless WeatherForecast.find_by(aquired_on: created_at)
  end

  # 作成更新時にcreated_atと同じ日付をcreated_onに設定
  def set_created_on
    self.created_on = self.created_at&.in_time_zone
  end
end
