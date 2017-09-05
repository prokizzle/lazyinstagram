class PgQueryWorker
    include Sidekiq::Worker

    def perform
       PgHero.capture_query_stats 
    end
end
