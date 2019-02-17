class Painel::TagsController < Painel::PainelController

    before_action :all_tags, only: [:create, :import_tweets]

    def create
        @tag = Tag.new(permitted_params)
        @tag.save!
    end

    def destroy
        if @tag = Tag.find(params[:id])
            @tag.destroy
        end
    end

    def import_tweets
        @name = params[:name]
        @id = params[:id]

        dispatch_event(params[:name])

        @tag = Tag.find(@id)
    end

    protected

    def permitted_params
        params.require(:tag).permit(:name)
    end

    def all_tags
        @tags = Tag.all
    end


    protected

    def dispatch_event(name)
        ActiveSupport::Notifications.instrument "twitter.import", { name: name }
    end

end
