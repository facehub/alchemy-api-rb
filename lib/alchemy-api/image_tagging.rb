module AlchemyAPI

  class ImageTagging < Base
    Config.add_mode :image_tagging, self

    def web_method
      'v3/classify'
    end

    def search(opts)
      check_options(opts)
      body = {apikey: Config.bluemix_apikey}.merge!(merged_options(options))
      @response = connection.get(path, body)
      parsed_response
    end

    def parsed_response
      case Config.output_mode
        when :json
          begin
            parsed = JSON.parse(@response.body)
            parsed[indexer].first['classifiers'].first['classes'] rescue nil
          rescue Exception => e
            {}
          end
        when :xml
        when :rdf
          fail NotImplementedError
      end
    end

    private

    def path
      "visual-recognition/api/#{web_method}"
    end

    def get_base_url
      'https://gateway-a.watsonplatform.net/'
    end


    def merged_options(opts = {})
      opts.merge({version: '2016-05-20'})
    end

    def supported_search_types
      [:url]
    end

    def indexer
      'images'
    end
  end

end