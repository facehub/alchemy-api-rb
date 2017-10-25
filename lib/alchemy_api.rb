require 'alchemy-api/version'
require 'alchemy-api/config'
require 'alchemy-api/base'
require 'alchemy-api/keyword_extraction'
require 'alchemy-api/text_extraction'
require 'alchemy-api/title_extraction'
require 'alchemy-api/entity_extraction'
require 'alchemy-api/face_detection'
require 'alchemy-api/sentiment_analysis'
require 'alchemy-api/targeted_sentiment_analysis'
require 'alchemy-api/relation_extraction'
require 'alchemy-api/concept_tagging'
require 'alchemy-api/text_categorization'
require 'alchemy-api/language_detection'
require 'alchemy-api/author_extraction'
require 'alchemy-api/taxonomy'
require 'alchemy-api/image_tagging'
require 'alchemy-api/combined_call'
require 'alchemy-api/emotion_analysis'
require 'alchemy-api/image_scene_text'

module AlchemyAPI

  BASE_URL = 'https://access.alchemyapi.com/calls/'

  def self.config
    Config
  end

  def self.configure
    block_given? ? yield(Config) : Config
  end

  def self.alchemy_key
    if !Config.apikey.is_a? Array
      return Config.apikey
    end
    @@apikey_mutex ||= Mutex.new
    @@apikey_mutex.synchronize do
      @@apikey_idx ||= -1
      @@apikey_idx = (@@apikey_idx + 1) % Config.apikey.size
      Config.apikey[@@apikey_idx]
    end
  end

  def self.alchemy_key=(value)
    @@apikey_idx = -1
    Config.apikey = value
  end

  def self.bluemix_key
    if !Config.bluemix_apikey.is_a? Array
      return Config.bluemix_apikey
    end
    @@bluemix_mutex ||= Mutex.new
    @@bluemix_mutex.synchronize do
      @@bluemix_apikey_idx ||= -1
      @@bluemix_apikey_idx = (@@bluemix_apikey_idx + 1) % Config.bluemix_apikey.size
      Config.bluemix_apikey[@@bluemix_apikey_idx]
    end
  end

  def self.bluemix_key=(value)
    @@bluemix_apikey_idx = -1
    Config.bluemix_apikey = value
  end

  def self.bluemix_apikey_idx
    @@bluemix_apikey_idx
  end

  def self.bluemix_apikey_idx=(value)
    @@bluemix_apikey_idx = value
  end

  def self.search(mode, opts)
    klass = Config.modes[mode]

    fail InvalidAPIKey unless Config.apikey
    fail InvalidSearchMode unless klass

    klass.new.search(opts)
  end

  class UnknownError < StandardError; end
  class MissingOptionsError < StandardError; end
  class InvalidAPIKey < StandardError; end
  class InvalidSearchMode < StandardError; end
  class InvalidOutputMode < StandardError; end
end
