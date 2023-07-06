module ApplicationHelper
  DAT_OF_WEEK = ["日", "月", "火", "水", "木", "金", "土"]

  # ページごとの完全なタイトルを返す
  def full_title(page_title = '')
    base_title = 'LiLy'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # カンマ区切り円に変換
  def add_comma_en(amount_sold = 0)
    "#{number_with_delimiter(amount_sold)}円"
  end

  # カンマ区切りに変換
  def add_comma(amount_sold = 0)
    "#{number_with_delimiter(amount_sold)}"
  end
  
  # 個数に変換
  def add_ko_sold(quantity_sold = 0)
    "#{quantity_sold}個"
  end 

  # 現在のページ数を取得する。
  def current_page_number(page_obj)
    if page_obj.present?
      unless page_obj.first_page?
        current_page = page_obj.count + (page_obj.current_page - 1) * 10 #←perメソッドの表示ページ数に応じて変更する。
        return "#{current_page}/#{page_obj.total_count}件"
      end
      return "#{page_obj.count}/#{page_obj.total_count}件"
    end
  end

  # 日付を曜日付きで取得する。
  def get_date(date = '')
    if date.present?
      # date.strftime("%Y年%-m月%-d日(#{DAT_OF_WEEK[date.wday]})")
      date.strftime("%-m月%-d日(#{DAT_OF_WEEK[date.wday]})")
    else
      '-'
    end
  end

  # 与えられた日付が祝日だった場合、その祝日名を取得する。
  def get_holiday(date = '')
    if HolidayJp.holiday?(date)
      holidays = HolidayJp.between(date, date)
      holidays.first.name
    else
      '祝日ではありません'
    end
  end
end
