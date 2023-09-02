module StaticPagesHelper
  def create_event_tag(obj)
    start_date = l(obj.start_time, format: :cal_title)
    end_date   = l(obj.end_time, format: :cal_title)
    start_time = l(obj.start_time, format: :cal_short)
    end_time   = l(obj.end_time, format: :cal_short)
    start_date_time = l(obj.start_time, format: :short)
    end_date_time   = l(obj.end_time, format: :short)

    # 日を跨ぐイベントの場合、日付も表示する。またがない場合は時間のみ表示する。
    return tag.div("#{start_date_time} - #{end_date_time}") unless start_date == end_date
    tag.div("#{start_time} - #{end_time}")
  end
end
