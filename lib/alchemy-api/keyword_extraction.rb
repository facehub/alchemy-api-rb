module AlchemyAPI
  class KeywordExtraction < Base
    Config.add_mode :keyword_extraction, self

    def web_method
      "#{method_prefix}GetRankedKeywords"
    end

    private

    def indexer
      nil
    end
  end
end
