class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.string :artist
      t.datetime :datetime
      t.string :venue
      t.decimal :price

      t.timestamps null: false
    end
  end
end
