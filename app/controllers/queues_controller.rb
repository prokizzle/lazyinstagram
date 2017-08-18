class QueuesController < ApplicationController
	def index
		female_photos = InstagramPhoto.tagged_with(['girl', 'female'], any: true, on: :labels).tagged_with('advertising', exclude: true)
		queues = { 
			analysis_queue: InstagramPhoto.where(scraped: nil).size,
			like_queue: InstagramPhoto.where(scraped: true, liked: false, gender: 'female').size,
			photos: InstagramPhoto.all.count,
			liked: InstagramPhoto.where(liked: true).count,
			most_popular_tags: ActsAsTaggableOn::Tag.most_used(15).map{|t| t.name},
			girls_on_vacation: female_photos.tagged_with('vacation').count,
			girls_eating_pizza: female_photos.tagged_with('pizza').count,
			girls_doing_yoga: female_photos.tagged_with('yoga').count,
			dogs: InstagramPhoto.tagged_with(['dog', 'dogs'], any: true).count,
			cats: InstagramPhoto.tagged_with(['cats', 'cat'], any: true).count,
			rappers: InstagramPhoto.tagged_with(['rapper']).count,
			girls_with_food: female_photos.tagged_with(['food']).count,
			female_models: female_photos.tagged_with(['model']).count,
			# images: female_photos.tagged_with('gym').shuffle.first(5).map{|photo| photo.url }
		}
		render json: { queues: queues}
	end
end