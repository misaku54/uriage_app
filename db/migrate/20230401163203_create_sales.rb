class CreateSales < ActiveRecord::Migration[7.0]
  def change
    create_table :sales do |t|
      t.integer :amount_sold, null: false
      t.text :remark
      t.references :user, null: false, foreign_key: true
      t.references :maker, null: false, foreign_key: true
      t.references :producttype, null: false, foreign_key: true

      t.timestamps
    end
  end
end
