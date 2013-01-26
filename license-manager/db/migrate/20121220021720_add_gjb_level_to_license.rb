class AddGjbLevelToLicense < ActiveRecord::Migration
  def change
    add_column :licenses,:gjb_level,:string
  end
end
