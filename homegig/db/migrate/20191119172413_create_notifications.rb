class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :from_user, index: true, class_name: "User" 
      t.belongs_to :to_user, index: true, class_name: "User"
      t.text :description
      t.boolean :checked
      t.timestamps
    end
  end
end
