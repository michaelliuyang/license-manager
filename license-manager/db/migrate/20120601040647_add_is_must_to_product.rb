class AddIsMustToProduct < ActiveRecord::Migration
  def change
    add_column :products, :is_must, :boolean
  end
end
