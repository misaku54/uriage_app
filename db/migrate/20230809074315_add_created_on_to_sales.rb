class AddCreatedOnToSales < ActiveRecord::Migration[7.0]
  def change
    add_column :sales, :created_on, :date, null: false
    add_foreign_key :sales, :weather_forecasts, column: :created_on, primary_key: :aquired_on
  end
end
