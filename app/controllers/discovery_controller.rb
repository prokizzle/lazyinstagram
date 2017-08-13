class DiscoveryController < ApplicationController
	skip_before_action :verify_authenticity_token
	
	def index
		respond_to do |format|
			format.html do
			end
			format.json do
				render json: DiscoverySearchTerm.all
			end
		end
	end

	def create
		DiscoverySearchTerm.create!(search_term: params[:search_term], radius: params[:radius])
	end
end