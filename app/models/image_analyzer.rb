class ImageAnalyzer
    def initialize(url:)
      @url = url
      @rekognition = Aws::Rekognition::Client.new
    end

    def open(url)
      Net::HTTP.get(URI.parse(url))
    end

    def labels
      image = open(@url)
      return {labels: []} if image == 'Invalid image encoding'
      @labels ||= @rekognition.detect_labels(
        {
          image: {
            bytes: image
          },
          min_confidence: 0
        }
      ).to_h
    rescue => e
      puts e.message
      return {labels: []}
    end

    def label_names
      labels[:labels].map{ |label| label[:name] }
    end

    def filter_by_labels(filters)
      _labels = labels[:labels].map{ |label| label[:name] }
      _labels.select{ |label| filters.include? label }.size > 0
    end

    def bad_image?
      labels[:labels].empty?
    end

    def gender
      hash = Hash.new({confidence: 0})
      genders = labels[:labels].select{|label| ['Female', 'Male'].include? label[:name] }
      genders.each do |gender|
        hash[gender[:name]] = {confidence: gender[:confidence]}
      end
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