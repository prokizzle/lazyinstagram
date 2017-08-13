class QueuesController < ApplicationController
	def index
		queues = { 
			analysis_queue: InstagramPhoto.where(scraped: nil).size,
			like_queue: InstagramPhoto.where(scraped: true, liked: false, gender: 'female').size,
			photos: InstagramPhoto.all.count,
			liked: InstagramPhoto.where(liked: true).count
		}
		render json: { queues: queues}
	end
end