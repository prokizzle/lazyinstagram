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
            :threshold => { :limit => 600, :period => 1.second }
        })
    end

    def perform
        photo = InstagramPhoto.where(scraped: [false,nil]).shuffle.sample
        unless photo.nil?
            client = ImageAnalysis::Client.new(url: photo.url, driver: driver)
            if client.bad_image?
                puts "Bad image", photo.url
                # photo.destroy!
            else
                photo.label_list.add(client.label_names)
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
