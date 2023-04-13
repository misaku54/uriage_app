module SalesHelper
  # インスタンスをchartkickメソッドの引数に渡す用の配列に変換する。
  def convert_array(aggregates, card_pattern)
    if aggregates.present?
      if card_pattern == "maker_producttype"
        aggregates.map do |aggregate|
          ["#{aggregate.maker_name} #{aggregate.producttype_name}",
          aggregate.sum_amount_sold] 
        end
      else
        aggregates.map do |aggregate|
          [aggregate.name, aggregate.sum_amount_sold] 
        end
      end
    else
      return nil
    end
  end

  # 集計結果のタイトルを求める。
  def make_aggregate_title(card_pattern)
    if card_pattern == 'maker_producttype'
      aggregate_title = '集計結果（メーカー、商品別の販売額の合計）'
    elsif card_pattern == 'maker'
      aggregate_title = '集計結果（メーカー別の販売額の合計）'
    else
      aggregate_title = '集計結果（商品別の販売額の合計）'
    end
  end
end
