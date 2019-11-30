class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.text :title
      t.text :content
      t.decimal :price
      t.belongs_to :category, index: true
      t.belongs_to :user, index: true
      t.string :gig_image, null: false, default: ""
      t.timestamps
    end
  end
end
