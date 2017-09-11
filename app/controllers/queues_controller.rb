class QueuesController < ApplicationController
	def index
        female_photos = InstagramPhoto.females
		queues = { 
			analysis_queue: InstagramPhoto.where(scraped: nil).size,
			like_queue: female_photos.where(scraped: true, liked: false).size,
			photos: InstagramPhoto.all.count,
			liked: InstagramPhoto.where(liked: true).count,
            unfollow_queue: Instagram::UserUnfollower.queue.count,
            followed: Follow.count,
		}
		render json: { queues: queues}
	end
end
