class TwitterService < Struct.new(:hashtag, :last_id)

    def self.import!(hashtag, last_id = nil)
        new(hashtag, last_id).import!
    end

    # ------------------------------------------
    # Inicia o processo de importação
    # ------------------------------------------
    def import!

        if hashtag.class.to_s != "String"
            return get_tweets
        end

        begin
            search_tweets!
        rescue Twitter::Error::TooManyRequests => e
            puts "==> #{e.to_s} <=="
            # Caso estoure o limite retorna o que já tem
            return get_tweets
        end
        get_tweets
    end

    protected

    # ------------------------------------------
    # Verifica se a string tem hashtag e se não tiver adiciona
    # ------------------------------------------
    def get_hashtag
        @get_hashtag ||= (hashtag[0] != '#') ? "##{hashtag}" : hashtag
    end

    # ------------------------------------------
    # Config para api do twitter
    # ------------------------------------------
    def twitter_config
        { since_id: last_id }
    end

    # ------------------------------------------
    # Retorna as info do secrets.yaml
    # ------------------------------------------
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
