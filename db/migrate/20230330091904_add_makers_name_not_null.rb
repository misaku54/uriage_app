class AddMakersNameNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :makers, :name, false
  end
end
