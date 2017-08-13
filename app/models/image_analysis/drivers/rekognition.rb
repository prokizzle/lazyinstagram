module ImageAnalysis
  module Drivers
    class Rekognition < Base
      attr_reader :client

      def initialize(url:)
        @client = Aws::Rekognition::Client.new
        @url = url
      end

      def api_result
        image = open(@url)
        return [] if image == 'Invalid image encoding'
        @labels ||= @client.detect_labels(
          {
            image: {
              bytes: image
            },
            min_confidence: 0
          }
        ).to_h[:labels]
      rescue => e
        puts e.message
        return []
      end

      def label_names
        @names ||= api_result.select do |label|
          label[:confidence] > 0.5
        end.map{ |label| label[:name].downcase }.uniq
      end

      def labels_include?(*filters)
      	filters.any? do |filter|
      		label_names.include?(filter)
      	end
      end

      def bad_image?
        api_result[:labels].empty?
      end

      def gender
        return nil if hash['Male'].nil? && hash['Female'].nil?
        return 'female' if hash['Male'].nil?
        return 'male' if hash['Female'].nil?
        if hash['Female'][:confidence].to_i > hash['Male'][:confidence].to_i
          'female'
        else
          'male'
        end
      end
    end
  end
end
