class ChangeTweetIdToAuthors < ActiveRecord::Migration[5.2]
  def change
    change_column :authors, :tweet_id, :bigint
  end
end
