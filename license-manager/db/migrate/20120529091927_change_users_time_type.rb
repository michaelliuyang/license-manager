class ChangeUsersTimeType < ActiveRecord::Migration
  def change
    change_column :users, :last_login_time, :timestamp
  end
end
