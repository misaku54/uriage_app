class CreateWeatherForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :weather_forecasts do |t|
      t.date :aquired_on, null: false, primary_key: true, default: -> { '(CURRENT_DATE)' } 
      t.integer :weather_id
      t.float :temp_max
      t.float :temp_min
      t.float :rainfall
      t.timestamps
    end
  end
end
