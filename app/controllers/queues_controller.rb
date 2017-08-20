class QueuesController < ApplicationController
	def index
		female_photos = InstagramPhoto.tagged_with(['girl', 'female'], any: true, on: :labels).tagged_with('advertising', exclude: true)
		queues = { 
			analysis_queue: InstagramPhoto.where(scraped: nil).size,
			like_queue: female_photos.where(scraped: true, liked: false).size,
			photos: InstagramPhoto.all.count,
			liked: InstagramPhoto.where(liked: true).count,
			most_popular_tags: ActsAsTaggableOn::Tag.most_used(15).map{|t| t.name},
            followed: Follow.count,
		}
		render json: { queues: queues}
	end
end
