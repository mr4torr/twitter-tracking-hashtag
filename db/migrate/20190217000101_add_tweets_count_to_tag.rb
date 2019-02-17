class AddTweetsCountToTag < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :tweets_count, :integer, default: 0
    change_column_default :tags, :processing, 0
  end
end
