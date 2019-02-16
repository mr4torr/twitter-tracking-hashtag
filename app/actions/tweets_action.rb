class TweetsAction < Struct.new(:hashtag)

    def self.update!(hashtag)
        new(hashtag).update!
    end

    def update!
        @author = {}
        get_tag.update_attributes(processing: true)
        ActiveRecord::Base.transaction do
            get_tweets.each(&:save!)
            get_tag.update_attributes(processing: false)
            get_tweets
        end
    end

    protected

    def get_author(tweet)
        if @author[tweet.user.id] != nil
            return @author[tweet.user.id]
        end

        first_or_create_author(tweet)
    end

    # Busca ou cria um novo author
    def first_or_create_author(tweet)
        @author[tweet.user.id] = Author.where({ tweet_id:  tweet.user.id }).first_or_create do |author|
            author.name = tweet.user.name
            author.slug = tweet.user.screen_name
            author.picture = tweet.user.profile_image_url_https
        end
    end

    def get_tweets
        TwitterService.new(get_hashtag, get_last_id).import!.map do |tweet|
            new_tweet(tweet)
        end
    end

    def new_tweet(tweet)
        get_tag.tweets.where(tweet_id: tweet.id).first_or_initialize do |new_tweet|
            new_tweet.author_id = get_author(tweet).id
            new_tweet.text = tweet.text
            new_tweet.tweet_id = tweet.id
            new_tweet.tweet_created_at = tweet.created_at
            new_tweet.retweet_count = tweet.retweet_count || 0
            new_tweet.favorite_count = tweet.favorite_count || 0
        end
    end

    def get_hashtag
        @get_hashtag ||= (hashtag[0] != '#') ? "##{hashtag}" : hashtag
    end

    def get_tag
        @get_tag ||= Tag.where(name: get_hashtag).first
    end

    def get_last
        @get_last ||= Tweet.tweet_last_by_hashtag(get_tag).first
    end

    def get_last_id
        @get_last_id ||= get_last ? get_last.tweet_id : nil
    end

end
