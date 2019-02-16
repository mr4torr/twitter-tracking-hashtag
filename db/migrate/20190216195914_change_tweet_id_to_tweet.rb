class ChangeTweetIdToTweet < ActiveRecord::Migration[5.2]
  def change
    change_column :tweets, :tweet_id, :bigint
  end
end
