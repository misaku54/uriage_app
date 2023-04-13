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

  # メーカー、商品別の合計販売額と販売数を集計する。
  scope :maker_producttype_sum_amount_sold, -> { joins(:maker, :producttype)
                                                  .select(
                                                    'makers.name as maker_name,
                                                    producttypes.name as producttype_name,
                                                    sum(sales.amount_sold) as sum_amount_sold,
                                                    count(*) as quantity_sold' )
                                                  .group('maker_name, producttype_name') }
  # メーカー別の合計販売額と販売数を集計する。
  scope :maker_sum_amount_sold, -> { joins(:maker)
                                      .select(
                                        'makers.name as name,
                                        sum(sales.amount_sold) as sum_amount_sold,
                                        count(*) as quantity_sold')
                                      .group('name') }
  # 商品別の合計販売額と販売数を集計する。
  scope :producttype_sum_amount_sold, -> { joins(:producttype)
                                            .select(
                                              'producttypes.name as name,
                                              sum(sales.amount_sold) as sum_amount_sold,
                                              count(*) as quantity_sold' )
                                            .group('name') }
  # 販売額の合計を降順で並び替え
  scope :sorted, -> { order('sum_amount_sold DESC') }
    
    
    
    scope :published, ->{ where("status <> ?", "draft") } #下書き以外の記事
    scope :full, ->(member) { where("status <> ? OR member_id = ?", "draft", member.id) } #下書き以外の記事または、本人の下書き
    scope :readable_for, ->(member) { member ? full(member) : common } #ログインしているかでスコープを分岐させる。




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
