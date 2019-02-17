class Tweet < ApplicationRecord
  belongs_to :author
  belongs_to :tag

  scope :tweet_last_by_hashtag, -> (tag_id) {
    where({ tag_id: tag_id })
        .order('tweet_created_at desc')
        .limit(1)
  }
end
