class Tweet < ApplicationRecord
  belongs_to :author
  belongs_to :tag

  scope :tweet_last_by_hashtag, -> (tag_id) {
    where({ tag_id: tag_id })
    .order('tweet_created_at desc')
    .limit(1)
}

scope :get_by_hashtag, -> (tag_ids = nil) {

    whereFind = tag_ids.present? ? { tag_id: tag_ids } : {}
    includes(:author).where(whereFind).order('tweet_created_at desc')

  }

#   def as_json(options={})
#     super(:only => [:first_name,:last_name,:city,:state],
#           :include => {
#             :employers => {:only => [:title]},
#             :roles => {:only => [:name]}
#           }
#     )
#   end

end
