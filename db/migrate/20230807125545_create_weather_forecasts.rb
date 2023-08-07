class CreateWeatherForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :weather_forecasts, id: false do |t|
      t.date :aquired_on, null: false, default: -> { '(CURRENT_DATE)' }, primary_key: true
      t.integer :weather_id
      t.float :temp_max
      t.float :temp_min
      t.float :rainfall
      t.timestamps
    end
  end
end
