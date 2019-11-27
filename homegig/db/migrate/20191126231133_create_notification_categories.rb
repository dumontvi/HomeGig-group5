class CreateNotificationCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_categories do |t|
      t.text :name
      t.timestamps
    end

    categories = ['Review', 'Payment', 'Interest', 'Approval']
    categories.each do |name|
      NotificationCategory.create(name: name)
    end
  end
end
