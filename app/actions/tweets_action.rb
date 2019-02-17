class TweetsAction < Struct.new(:hashtag)

    def self.update!(hashtag)
        new(hashtag).update!
    end

    # ------------------------------------------
    # Inicia o processo de importação
    # ------------------------------------------
    def update!
        @author = {}

        get_hashtag.update_attributes(processing: true)
        ActiveRecord::Base.transaction do
            get_hashtag.processing = false
            get_hashtag.tweets_count += get_tweets.compact.length
            get_hashtag.save!
        end
    end

    protected

    # ------------------------------------------
    # Retorna o registro do autor do tweet
    # ------------------------------------------
    def get_author(tweet)
        if @author[tweet.user.id] != nil
            return @author[tweet.user.id]
        end

        first_or_create_author(tweet)
    end

    # ------------------------------------------
    # Busca ou cria um novo autor
    # ------------------------------------------
    def first_or_create_author(tweet)
        @author[tweet.user.id] = Author.where({ tweet_id:  tweet.user.id }).first_or_create do |author|
            author.name = tweet.user.name
            author.slug = tweet.user.screen_name
            author.picture = tweet.user.profile_image_url_https
        end
        return @author[tweet.user.id]
    end

    # ------------------------------------------
    # Cria um novo objeto tweet, vincula o autor e tag
    # ------------------------------------------
    def new_tweet(tweet)
        get_hashtag.tweets.build({
            tweet_id: tweet.id,
            author_id: get_author(tweet).id,
            text: tweet.text,
            tweet_id: tweet.id,
            tweet_created_at: tweet.created_at,
            retweet_count: tweet.retweet_count || 0,
            favorite_count: tweet.favorite_count || 0
        })
    end

    # ------------------------------------------
    # Executa o processo de importação dos tweets
    # ------------------------------------------
    def twitter_tweets
        @twitter_tweets ||= TwitterService.new(get_with_hashtag, get_hashtag_last_id).import!
    end


    # ------------------------------------------
    # Associa o tweet ao objeto tag
    # ------------------------------------------
    def get_tweets
        @get_tweets ||= twitter_tweets.map do |tweet|
            new_tweet(tweet) if !get_tweet_ids.include?(tweet.id)
        end
    end

    # ------------------------------------------
    # Verifica se a string tem hashtag e se não tiver adiciona
    # ------------------------------------------
    def get_with_hashtag
        @get_with_hashtag ||= (hashtag[0] != '#') ? "##{hashtag}" : hashtag
    end

    # ------------------------------------------
    # Verifica se a string não tem hashtag e se tiver remove
    # ------------------------------------------
    def get_without_hashtag
        @get_without_hashtag ||= get_with_hashtag[1..get_with_hashtag.chars.length]
    end

    # ------------------------------------------
    # Retorna o id do ultimo tweet
    # ------------------------------------------
    def get_hashtag_last_id
        @get_hashtag_last_id ||= get_hashtag_last ? get_hashtag_last.tweet_id : nil
    end

    # ------------------------------------------
    # Retorna a tag paratir do que foi definido na func. update!
    # ------------------------------------------
    def get_hashtag
        @get_hashtag ||= Tag.where(name: get_without_hashtag).first
    end

    # ------------------------------------------
    # Retorna o último tweet da tag para buscar a partir dessa
    # ------------------------------------------
    def get_hashtag_last
        @get_hashtag_last ||= Tweet.tweet_last_by_hashtag(get_hashtag).first
    end

    # ------------------------------------------
    # Retorna todos os identificador no twitter já cadastrados
    # ------------------------------------------
    def get_tweet_ids
        @get_tweet_ids ||= Tweet.select('tweet_id').where(tag: get_hashtag).pluck(:tweet_id)
    end

end
