class AddProducttypesNameNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :producttypes, :name, false
  end
end
