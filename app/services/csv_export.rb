# csv出力ロジックモデル
class CsvExport
  BOM = "\uFEFF"
  def self.maker_csv_output(makers)
    CSV.generate(BOM) do |csv|
      csv << ["メーカー名","登録日時"]
      makers.each do |maker|
        csv << [maker.name, maker.created_at.strftime("%Y/%m/%d %H:%M")]
      end
    end
  end

  def self.producttype_csv_output(producttypes)
    CSV.generate(BOM) do |csv|
      csv << ["商品分類名","登録日時"]
      producttypes.each do |producttype|
        csv << [producttype.name, producttype.created_at.strftime('%Y/%m/%d %H:%M')]
      end
    end
  end

  def self.sale_csv_output(sales)
    CSV.generate(BOM) do |csv|
      csv << ['メーカー名','商品分類名','販売価格','備考','登録日時']
      sales.each do |sale|
        maker_name = sale.maker.present? ? sale.maker.name : '未登録'
        producttype_name = sale.producttype.present? ? sale.producttype.name : '未登録'
        csv << [maker_name, producttype_name, sale.amount_sold, sale.remark, sale.created_at.strftime('%Y/%m/%d %H:%M') ]
      end
    end
  end

  def self.aggregate_csv_output(sales_total_amount, sales_growth_rate, aggregates_of_maker_producttype, aggregates_of_maker, aggregates_of_producttype)
    CSV.generate(BOM) do |csv|
      csv << ['合計純売上']
      csv << ['純売上', '前年比']     
      csv << [sales_total_amount, sales_growth_rate]     

      csv << ['']
      csv << ['売上集計（メーカー×商品分類）']
      csv << ['メーカー名', '商品分類名', '純売上', '販売数量', '昨年の純売上', '昨年の販売数量','成長率（前年比較）']     
      aggregates_of_maker_producttype.each do |aggregate|
        csv << [
          aggregate.maker_name, aggregate.producttype_name, aggregate.sum_amount_sold, aggregate.quantity_sold,
          aggregate.last_year_sum_amount_sold, aggregate.last_year_quantity_sold, aggregate.sales_growth_rate
        ]
      end

      csv << ['']
      csv << ['売上集計（メーカー）']
      csv << ['メーカー名', '純売上', '販売数量', '昨年の純売上', '昨年の販売数量', '成長率（前年比較）']     
      aggregates_of_maker.each do |aggregate|
        csv << [
          aggregate.maker_name, aggregate.sum_amount_sold, aggregate.quantity_sold,
          aggregate.last_year_sum_amount_sold, aggregate.last_year_quantity_sold, aggregate.sales_growth_rate
        ]
      end

      csv << ['']
      csv << ['売上集計（商品分類）']
      csv << ['商品分類名', '純売上', '販売数量', '昨年の純売上', '昨年の販売数量', '成長率（前年比較）']     
      aggregates_of_producttype.each do |aggregate|
        csv << [
          aggregate.producttype_name, aggregate.sum_amount_sold, aggregate.quantity_sold,
          aggregate.last_year_sum_amount_sold, aggregate.last_year_quantity_sold, aggregate.sales_growth_rate
        ]
      end
    end
  end
end