class Painel::DashboardController < Painel::PainelController

    before_action :get_tweets

    def index
        @tags = Tag.all if !request.xhr?
    end

    protected

    def get_tweets
        @tweets = Tweet.get_by_hashtag.page(params[:page])
    end
end
