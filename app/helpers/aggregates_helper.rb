module AggregatesHelper
  # リレーションインスタンスをchartkickメソッドの引数に渡す用の配列に変換する。
  def convert_array(aggregates, pattern)
    if aggregates.present?
      # 引数で渡した集計結果が、
      # ①メーカー、商品別　②メーカー別　③商品別のうち
      # どのパターンの集計結果なのかで、変換する配列の中身を切り替える。
      if pattern == 'maker_producttype'
        return aggregates.map do |aggregate|
          ["#{aggregate.maker_name} #{aggregate.producttype_name}", aggregate.sum_amount_sold] 
        end
      end

      if pattern == 'maker'
        return aggregates.map do |aggregate|
          [aggregate.maker_name, aggregate.sum_amount_sold] 
        end
      end

      if pattern == 'producttype'
        return aggregates.map do |aggregate|
          [aggregate.producttype_name, aggregate.sum_amount_sold] 
        end
      end
      raise
    end
  end

  # 集計結果のタイトルを求める。
  def make_aggregate_title(pattern)
    return aggregate_title = '集計結果（メーカー、商品別の販売額の合計）'   if pattern == 'maker_producttype'
    return aggregate_title = '集計結果（メーカー別の販売額の合計）'        if pattern == 'maker'
    return aggregate_title = '集計結果（商品別の販売額の合計）'           if pattern == 'producttype'
    raise
  end

  # 検索結果のタイトルを求める。
  def search_result_title(params, period)
    if period == 'daily' && params.start_date.present? && params.end_date.present? 
      return "#{params.start_date.in_time_zone.year}年#{params.start_date.in_time_zone.month}月#{params.start_date.in_time_zone.day}日から
              #{params.end_date.in_time_zone.year}年#{params.end_date.in_time_zone.month}月#{params.end_date.in_time_zone.day}までの集計結果"
    end

    if period == 'monthly' && params.date.present?
      return "#{params.date.year}年 #{params.date.month}月の集計結果"
    end  
    
    if period == 'yearly' && params.date.present? 
      return "#{params.date.year}年の集計結果"
    end
  end
end
