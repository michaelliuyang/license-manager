class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :custom_name
      t.string :applicant
      t.text :publish_reason
      t.text :publish_content
      t.date :expires_date
      t.string :version
      t.string :local_check_type
      t.string :local_check
      t.integer :user_number
      t.text :memo

      t.timestamps
    end
  end
end
