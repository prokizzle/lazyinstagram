class AnalyzePhotosWorker
    include Sidekiq::Worker
    include Sidekiq::Throttled::Worker
    sidekiq_options queue: :analysis

    if ENV['analysis_provider'] == 'rekognition'
        sidekiq_throttle({
            :concurrency => { :limit => 5 },
            :threshold => { :limit => 1_000, :period => 1.day }
        })
    else
        sidekiq_throttle({
            :concurrency => { :limit => 5 },
            :threshold => { :limit => 600, :period => 1.minute }
        })
    end

    def perform
        photo = InstagramPhoto.where(scraped: [false,nil]).shuffle.sample
        unless photo.nil?
            if Faraday.head(photo.url).status == 404
                puts "Bad image", photo.url
                photo.destroy!
                perform
            else
                client = ImageAnalysis::Client.new(url: photo.url, driver: driver)
                photo.tags += client.label_names
                if client.labels_include?('female', 'girl')
                    photo.gender = 'female'
                end
                photo.scraped = true
                photo.save
            end
        end
    end

    def driver
        "ImageAnalysis::Drivers::#{ENV['analysis_provider'].camelcase}".constantize
    end
end

ProcessPhotosWorker = AnalyzePhotosWorker
