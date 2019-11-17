class CreateGigs < ActiveRecord::Migration[6.0]
  def change
    create_table :gigs do |t|
      t.string :title
      t.text :description
      t.string :price

      t.timestamps
    end
  end
end
