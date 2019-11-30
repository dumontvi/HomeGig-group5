class CreateSposts < ActiveRecord::Migration[6.0]
  def change
    create_table :sposts do |t|
      t.text :title
      t.text :content
      t.decimal :price
      t.belongs_to :category, index: true
      t.belongs_to :user, index: true
      t.string :seek_gig_image, null: false, default: ""
      t.timestamps
    end
  end
end
