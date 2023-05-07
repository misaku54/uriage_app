module ApplicationHelper
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
  
  # 個数に変換
  def add_ko_sold(quantity_sold = 0)
    "#{quantity_sold}個"
  end 

  # 不要。確認後に消す
  def html_safe_newline(str)
    h(str).gsub(/\n|\r|\r\n/, "<br>").html_safe
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

  # turbo_streamでフラッシュを表示する際に使うヘルパー
  def turbo_stream_flash
    turbo_stream.update "flash", partial: "layouts/flash"
  end
end
