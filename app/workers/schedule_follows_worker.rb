class ScheduleFollowsWorker
    include Sidekiq::Worker

    sidekiq_options queue: :follows

    def perform
        return if Instagram::Account.new.total_following > 500
        InstagramPhoto.females.find_each do |female|
            FollowUserWorker.perform_async(female.user_id)
        end
    end
end
