class CreateStars < ActiveRecord::Migration[7.1]
  def change
    create_table :stars do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
    add_index :stars, [:user_id, :post_id], unique: true
  end
end 