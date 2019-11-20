class AddNotificationToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :notification, foreign_key: true
  end
end
