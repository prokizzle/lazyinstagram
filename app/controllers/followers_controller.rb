class FollowersController < ApplicationController
    def index
        if params[:ids].presence
            render json: Instagram::Account.new.follower_ids
        else
            render json: Instagram::Account.new.followers
        end
    end
end
