module ApplicationHelper
  # 定数宣言
  DAT_OF_WEEK = ["日", "月", "火", "水", "木", "金", "土"]

  # ページごとの完全なタイトルを返す
  def full_title(page_title = "")
    base_title = "LiLy"
    return base_title if page_title.empty?
    "#{page_title} | #{base_title}"
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
    return "0件" if page_obj.blank?
    unless page_obj.first_page?
      current_page = page_obj.count + (page_obj.current_page - 1) * 10 #←perメソッドの表示ページ数に応じて変更する。
      return "#{current_page}/#{page_obj.total_count}件"
    end
    return "#{page_obj.count}/#{page_obj.total_count}件"
  end

  # 日付を曜日付きで取得する。
  def get_date(date)
    return '-' if date.blank?
    date.strftime("%-m月%-d日(#{DAT_OF_WEEK[date.wday]})")
  end

  # 与えられた日付が祝日だった場合、その祝日名を取得する。
  def get_holiday(date)
    return "-" unless HolidayJp.holiday?(date) 
    holidays = HolidayJp.between(date, date)
    holidays.first.name
  end

  # 天気情報の取得
  def get_weather(weather_code)
    return "不明"             if weather_code.blank?
    return "快晴\u{2600}"     if weather_code == 0
    return "晴れ\u{2600}"     if weather_code == 1
    return "一部曇\u{1F324}"  if weather_code == 2
    return "曇り\u{2601}"   if weather_code == 3
    return "霧\u{1F32B}"     if weather_code <= 49
    return "霧雨\u{1F32B}"   if weather_code <= 59
    return "雨\u{1F327}"     if weather_code <= 69
    return "雪\u{26C4}"     if weather_code <= 79
    return "俄か雨\u{1F327}"  if weather_code <= 84
    return "雪・雹\u{2603}"  if weather_code <= 94
    return "雷雨\u{26C8}"    if weather_code <= 99
    "不明"
  end
end
