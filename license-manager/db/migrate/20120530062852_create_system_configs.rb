class CreateSystemConfigs < ActiveRecord::Migration
  def change
    create_table :system_configs do |t|
      t.string :site_name
      t.string :license_path

      t.timestamps
    end
  end
end
