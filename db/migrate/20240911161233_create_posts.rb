class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :brand
      t.string :model
      t.string :body_type
      t.integer :mileage
      t.string :color
      t.integer :price
      t.string :fuel
      t.integer :year
      t.float :engine_capacity
      t.string :phone_number
      t.string :name

      t.timestamps
    end
  end
end