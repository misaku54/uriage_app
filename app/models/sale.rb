class Sale < ApplicationRecord
  include SessionsHelper
  belongs_to :user
  belongs_to :maker
  belongs_to :producttype

  # 販売価格は数値のみで1円以上
  validates :amount_sold, numericality: { greater_than_or_equal_to: 1 }
  # 備考は1000文字まで
  validates :remark, length: { maximum: 1000 }
  validates :created_at, presence: true
  # 登録していないメーカー名や商品名で更新できない
  validate :maker_id_should_be_registered
  validate :producttype_id_should_be_registered

  # 集計用SQL
  sql_1 = <<-EOS
  SELECT k.maker_name, k.producttype_name, k.sum_amount_sold current_year_amount, k.quantity_sold current_year_quantity,
  COALESCE(z.sum_amount_sold, 0) last_year_amount, COALESCE(z.quantity_sold, 0) last_year_quantity
    FROM (SELECT m.name maker_name, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      INNER JOIN makers m ON m.id = s.maker_id
      INNER JOIN producttypes p ON p.id = s.producttype_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :current_year_start AND :current_year_end
      GROUP BY maker_name, producttype_name) k
    LEFT JOIN (SELECT m.name maker_name, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      INNER JOIN makers m 
      ON m.id = s.maker_id
      INNER JOIN producttypes p 
      ON p.id = s.producttype_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :last_year_start AND :last_year_end
      GROUP BY maker_name, producttype_name) z
    ON k.maker_name = z.maker_name AND k.producttype_name = z.producttype_name
    ORDER BY current_year_amount DESC
  EOS

  sql_2 = <<-EOS
  SELECT k.maker_name, k.sum_amount_sold current_year_amount, k.quantity_sold current_year_quantity,
  COALESCE(z.sum_amount_sold, 0) last_year_amount, COALESCE(z.quantity_sold, 0) last_year_quantity
    FROM (SELECT m.name maker_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      INNER JOIN makers m 
      ON m.id = s.maker_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :current_year_start AND :current_year_end
      GROUP BY maker_name) k
    LEFT JOIN (SELECT m.name maker_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      INNER JOIN makers m 
      ON m.id = s.maker_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :last_year_start AND :last_year_end
      GROUP BY maker_name) z
    ON k.maker_name = z.maker_name
    ORDER BY current_year_amount DESC
  EOS

  sql_3 = <<-EOS
  SELECT k.producttype_name, k.sum_amount_sold current_year_amount, k.quantity_sold current_year_quantity,
  COALESCE(z.sum_amount_sold, 0) last_year_amount, COALESCE(z.quantity_sold, 0) last_year_quantity
    FROM (SELECT p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      INNER JOIN producttypes p 
      ON p.id = s.producttype_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :current_year_start AND :current_year_end
      GROUP BY producttype_name) k
    LEFT JOIN (SELECT p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
      FROM sales s
      INNER JOIN producttypes p 
      ON p.id = s.producttype_id
      WHERE s.user_id = :user_id AND s.created_at BETWEEN :last_year_start AND :last_year_end
      GROUP BY producttype_name) z
    ON k.producttype_name = z.producttype_name
    ORDER BY current_year_amount DESC
  EOS

  # メーカー、商品別の合計販売額と販売数を集計する。
  scope :maker_producttype_sum_amount_sold, -> (user, search_params) { find_by_sql([sql_1,{ user_id: user.id,
                                                                                            current_year_start: search_params.date.in_time_zone.beginning_of_year,
                                                                                            current_year_end: search_params.date.in_time_zone.end_of_year,
                                                                                            last_year_start: search_params.date.in_time_zone.prev_year.beginning_of_year,
                                                                                            last_year_end: search_params.date.in_time_zone.prev_year.end_of_year }]) }
  # メーカー別の合計販売額と販売数を集計する。
  scope :maker_sum_amount_sold, -> (user, search_params) { find_by_sql([sql_2,{ user_id: user.id,
                                                                                current_year_start: search_params.date.in_time_zone.beginning_of_year,
                                                                                current_year_end: search_params.date.in_time_zone.end_of_year,
                                                                                last_year_start: search_params.date.in_time_zone.prev_year.beginning_of_year,
                                                                                last_year_end: search_params.date.in_time_zone.prev_year.end_of_year }]) }
  # 商品別の合計販売額と販売数を集計する。
  scope :producttype_sum_amount_sold, -> (user, search_params) { find_by_sql([sql_3,{ user_id: user.id,
                                                                                      current_year_start: search_params.date.in_time_zone.beginning_of_year,
                                                                                      current_year_end: search_params.date.in_time_zone.end_of_year,
                                                                                      last_year_start: search_params.date.in_time_zone.prev_year.beginning_of_year,
                                                                                      last_year_end: search_params.date.in_time_zone.prev_year.end_of_year }]) }
  # 販売額の合計を降順で並び替え
  scope :sorted, -> { order('sum_amount_sold DESC') }
    
  private 

  # バリデーションメソッド
  def maker_id_should_be_registered
    # 空白やnilの場合はこのバリデーションをスキップする。
    unless maker_id.blank?
      select_maker = Maker.find_by(id: maker_id, user_id: user_id)
      errors.add(:maker_id, 'は不正な値です') unless select_maker
    end
  end

  def producttype_id_should_be_registered
    unless producttype_id.blank?
      select_producttype = Producttype.find_by(id: producttype_id, user_id: user_id)
      errors.add(:producttype_id, 'は不正な値です', allow_blank: true) unless select_producttype
    end
  end
end
