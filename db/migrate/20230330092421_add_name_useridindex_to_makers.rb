class AddNameUseridindexToMakers < ActiveRecord::Migration[7.0]
  def change
    add_index :makers,[:name, :user_id], unique: true
  end
end
