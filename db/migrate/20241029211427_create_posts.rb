class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.text :body
      t.string :username
      t.integer :num_comments

      t.timestamps
    end
  end
end
