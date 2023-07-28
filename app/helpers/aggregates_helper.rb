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
      raise ArgmentError.new("無効な引数が渡されました。#{pettern}")
    end
  end
  
  # best_selling_cardの見出しを作成
  def make_title(pattern)
    return 'メーカー×商品分類' if pattern == 'maker_producttype'
    return 'メーカー' if pattern == 'maker'
    return '商品分類' if pattern == 'producttype'
    raise ArgmentError.new("無効な引数が渡されました。#{pattern}")
  end

  def make_card_class_name(pattern)
    return 'bg-success' if pattern == 'maker_producttype'
    return 'bg-warning' if pattern == 'maker'
    return 'bg-danger' if pattern == 'producttype'
  end

  # ランキングのタイトルを求める。
  def make_ranking_title(aggregate)
    if aggregate.respond_to?('maker_name') && aggregate.respond_to?('producttype_name')
      return '売上ランキング（メーカー、商品分類別）'
    end

    if aggregate.respond_to?('maker_name')
      return '売上ランキング（メーカー別）'
    end
    
    if aggregate.respond_to?('producttype_name')
      return '売上ランキング（商品分類別）' 
    end
    raise ArgmentError.new("無効な引数が渡されました。#{aggregate}")
  end

  # ランクインした名前を求める。
  def make_ranking_name(aggregate)
    if aggregate.respond_to?('maker_name') && aggregate.respond_to?('producttype_name')
      return "#{aggregate.maker_name}の#{aggregate.producttype_name}"  
    end

    if aggregate.respond_to?('maker_name')
      return aggregate.maker_name
    end
    
    if aggregate.respond_to?('producttype_name')
      return aggregate.producttype_name  
    end
    raise ArgmentError.new("無効な引数が渡されました。#{aggregate}")
  end

  # 集計結果のタイトルを求める。
  def make_aggregate_title(pattern)
    return '集計結果（メーカー、商品分類別の販売額の合計）' if pattern == 'maker_producttype'
    return '集計結果（メーカー別の販売額の合計）' if pattern == 'maker'
    return '集計結果（商品分類別の販売額の合計）' if pattern == 'producttype'          
    raise ArgmentError.new("無効な引数が渡されました。#{pettern}")
  end

  # 検索パラメータの取得
  def search_result_title(params, period)
    if period == 'daily' && params.start_date.present? && params.end_date.present? 
      return "#{params.start_date.in_time_zone.year}年#{params.start_date.in_time_zone.month}月#{params.start_date.in_time_zone.day}日から
              #{params.end_date.in_time_zone.year}年#{params.end_date.in_time_zone.month}月#{params.end_date.in_time_zone.day}まで"
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
