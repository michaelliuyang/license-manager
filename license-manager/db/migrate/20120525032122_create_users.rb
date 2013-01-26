class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login_name,:null => false
      t.string :password,:null => false
      t.string :name,:null => false
      t.string :email
      t.date :last_login_time
      t.string :last_login_ip
      t.boolean :is_lock,:default => false
      t.boolean :is_admin,:default => false

      t.timestamps
    end
  end
end
