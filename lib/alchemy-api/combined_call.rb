module AlchemyAPI
  class CombinedCall < Base
    Config.add_mode :combined, self

    # Parameter :extract
    # Comma separated list of requested features. Possible values:
    # page-image
    # image-kw
    # feed
    # entity
    # keyword
    # taxonomy
    # concept
    # relation
    # pub-date
    # doc-sentiment

    def web_method
      "#{method_prefix}GetCombinedData"
    end

    private

    def check_options(opts)
      super(opts)
      fail MissingOptionsError unless options[:extract]
    end

    def indexer
      nil
    end
  end
end
