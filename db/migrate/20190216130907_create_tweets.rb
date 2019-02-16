class CreateTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets do |t|
      t.integer :tweet_id
      t.text :text
      t.references :author, foreign_key: true
      t.references :tag, foreign_key: true
      t.integer :retweet_count
      t.integer :favorite_count
      t.datetime :tweet_created_at

      t.timestamps
    end
  end
end
