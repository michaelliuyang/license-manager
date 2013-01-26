class CreateLicenseProductships < ActiveRecord::Migration
  def change
    create_table :license_productships do |t|
      t.integer :license_id,:null => false
      t.integer :product_id,:null => false

      t.timestamps
    end
     add_index :license_productships, [:license_id, :product_id], :unique => true
  end
end
