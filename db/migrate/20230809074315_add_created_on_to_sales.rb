class AddCreatedOnToSales < ActiveRecord::Migration[7.0]
  def change
    add_column :sales, :created_on, :date, null: false
  end
end
