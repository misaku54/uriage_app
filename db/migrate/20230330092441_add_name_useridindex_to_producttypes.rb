class AddNameUseridindexToProducttypes < ActiveRecord::Migration[7.0]
  def change
    add_index :producttypes,[:name, :user_id], unique: true
  end
end
