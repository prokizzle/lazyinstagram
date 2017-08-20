class FollowsController < ApplicationController
    def index
        render json: Instagram::Account.new.following
    end
end
