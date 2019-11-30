class ChangeTypeOfPriceColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :price, :integer
    change_column :sposts, :price, :integer
  end
end
