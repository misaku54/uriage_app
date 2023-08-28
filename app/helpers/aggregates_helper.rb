module AggregatesHelper
  # 生SQLで取得したオブジェクト配列をchartkickメソッドの引数に渡す用の配列に変換する。
  def convert_array(aggregates, pattern)
    # aggregatesにnil値が入るのは想定していないため、raiseする
    return raise ArgumentError.new("無効な引数が渡されました。aggregatesに空値またはnilが渡されてます。") if aggregates.blank?

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
    # patternに３パターン以外の値が入るのは想定していないため、raiseする
    raise ArgumentError.new("無効な引数が渡されました。pattern: #{pattern}")
  end
  
  # best_selling_cardの見出しを作成
  def make_title(pattern)
    return 'メーカー×商品分類' if pattern == 'maker_producttype'
    return 'メーカー' if pattern == 'maker'
    return '商品分類' if pattern == 'producttype'
    # ３パターン以外の値が入るのは想定していないため、raiseする
    raise ArgumentError.new("無効な引数が渡されました。pattern: #{pattern}")
  end

  # 色を決める
  def make_color(pattern = '')
    # 引数なしでも色を取得したいために「|| pattern == ''」が条件にある。
    return '#003793' if pattern == 'maker_producttype' || pattern == ''
    return '#69AADE' if pattern == 'maker'
    return '#009E96' if pattern == 'producttype'
    # ３パターン以外の値が入るのは想定していないため、raiseする
    raise ArgumentError.new("無効な引数が渡されました。pattern: #{pattern}")
  end


  # 最も売れた項目の名前を求める。
  def best_selling_name(aggregate)
    if aggregate.respond_to?('maker_name') && aggregate.respond_to?('producttype_name')
      return "#{aggregate.maker_name}の#{aggregate.producttype_name}"  
    end

    if aggregate.respond_to?('maker_name')
      return aggregate.maker_name
    end
    
    if aggregate.respond_to?('producttype_name')
      return aggregate.producttype_name  
    end
    # ３パターン以外の値が入るのは想定していないため、raiseする
    raise ArgumentError.new("無効な引数が渡されました。aggregate:#{aggregate}")
  end


  # 検索パラメータの取得
  def search_result_title(params, period)
    if period == 'daily' && params.start_date.present? && params.end_date.present? 
      return "#{params.start_date.in_time_zone.year}年#{params.start_date.in_time_zone.month}月#{params.start_date.in_time_zone.day}日から#{params.end_date.in_time_zone.year}年#{params.end_date.in_time_zone.month}月#{params.end_date.in_time_zone.day}日まで"
    end

    if period == 'monthly' && params.date.present?
      return "#{params.date.in_time_zone.year}年 #{params.date.in_time_zone.month}月"
    end  
    
    if period == 'yearly' && params.date.present? 
      return "#{params.date.in_time_zone.year}年"
    end
    nil
  end
end
