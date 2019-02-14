class HomeController < ApplicationController

    before_action :authenticate_user!

    def index
    end

    protected

    def authenticate_user!
        redirect_to painel_dashboard_path if user_signed_in?
    end
end
