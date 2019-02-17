class Painel::PainelController < ApplicationController

    before_action :authenticate_user!
    helper_method :hashtag_ids


    def hashtag_ids
        @hashtag_ids ||= params[:hashtag].present? ? hashtag_params : hashtag_all
    end

    def hashtag_params
        params[:hashtag].map{ |n| n.to_i }.uniq
    end

    def hashtag_all
        Tag.all.pluck(:id)
    end

end
