class Painel::PainelController < ApplicationController

    before_action :authenticate_user!
end
