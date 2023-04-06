module ApplicationHelper
  # ページごとの完全なタイトルを返す
  def full_title(page_title = '')
    base_title = 'せるまね'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # 円に変換
  def add_en_sold(amount_sold = 0)
    "#{amount_sold}円"
  end
end
