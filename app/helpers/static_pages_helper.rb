module StaticPagesHelper
  def create_event_tag(obj)
    start_date = l(obj.start_time, format: :cal_title)
    end_date   = l(obj.end_time, format: :cal_title)
    start_date_time = l(obj.start_time, format: :short)
    end_date_time   = l(obj.end_time, format: :short)
    start_time = l(obj.start_time, format: :cal_short)
    end_time   = l(obj.end_time, format: :cal_short)

    return tag.div("#{start_date_time} - #{end_date_time}") unless start_date == end_date
    tag.div("#{start_time} - #{end_time}")
  end
end
