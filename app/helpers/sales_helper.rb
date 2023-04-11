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
end
