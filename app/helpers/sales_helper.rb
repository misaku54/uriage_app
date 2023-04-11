module SalesHelper
  # インスタンスをchartkickメソッドの引数に渡す用の配列に変換する。
  def convert_array(aggregates)
    if aggregates.present?
      aggregates.map do |aggregate|
        ["#{aggregate.maker_name} #{aggregate.producttype_name}",
        aggregate.sum_amount_sold] 
      end
    else
      return nil
    end
  end
end
