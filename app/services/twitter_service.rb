class TwitterService < Struct.new(:hashtag, :last_id)

    def self.import!(hashtag, last_id = nil)
        new(hashtag, last_id).import!
    end

    def import!

        if hashtag.class.to_s != "String"
            return get_tweets
        end

        begin
            search_tweets!
        rescue Twitter::Error::TooManyRequests => e
            puts "==> #{e.to_s} <=="
            return get_tweets
        end
        get_tweets
    end

    protected

    def get_hashtag
        @get_hashtag ||= (hashtag[0] != '#') ? "##{hashtag}" : hashtag
    end

    def twitter_config
        {
            result_type: 'recent',
            since_id: last_id || nil
        }
    end

    def secret_config
        @secret_config ||= Rails.application.secrets.twitter
    end

    def search_tweets!
        client.search(get_hashtag, twitter_config).collect do |tweet|
            set_tweet(tweet) if tweet.is_a?(Twitter::Tweet)
        end
    end

    def set_tweet(tweet)
        get_tweets << tweet
    end

    def get_tweets
        @get_tweets ||= []
    end

    def client
        @client ||= Twitter::REST::Client.new do |setup|
            setup.consumer_key        = secret_config[:api_key]
            setup.consumer_secret     = secret_config[:secret_key]
            setup.access_token        = secret_config[:access_token]
            setup.access_token_secret = secret_config[:secret_token]
        end
    end
end
