class CreateAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :authors do |t|
      t.integer :tweet_id
      t.string :name
      t.string :slug
      t.string :picture

      t.timestamps
    end
  end
end
