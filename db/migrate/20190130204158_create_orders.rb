class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.belongs_to :product, foreign_key: true
      t.string :customer_name
      t.string :adress
      t.string :zip_code
      t.string :shipping_method
      t.string :aasm_state
      t.string :fedex_id
      t.datetime :fedex_status_checked_at
      t.timestamps
    end
  end
end
