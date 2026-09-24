class CreateInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    create_table :invoice_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.string :product, null: false
      t.decimal :unit_price, precision: 12, scale: 2, null: false

      t.timestamps
    end
  end
end