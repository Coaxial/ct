class AddSoldoutToConcerts < ActiveRecord::Migration
  def change
    add_column :concerts, :soldout, :boolean
  end
end
