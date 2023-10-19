class ChangeCreatedOnToSale < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :sales, :weather_forecasts, column: :created_on, primary_key: :aquired_on
  end
end
