require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe AlchemyAPI do
  subject { AlchemyAPI }

  before do
    AlchemyAPI.bluemix_apikey_idx = -1
  end

  it 'knows the secure alchemy api url' do
    AlchemyAPI::BASE_URL.must_be :==, 'https://access.alchemyapi.com/calls/'
  end

  it 'allows you to set the alchemy key directly' do
    key = 'xxxxxxxx'
    AlchemyAPI.alchemy_key = key

    AlchemyAPI.alchemy_key.must_be :==, key
  end

  it 'allows you to set the bluemix key directly' do
    key = 'xxxxxxxx'
    AlchemyAPI.bluemix_key = key

    AlchemyAPI.bluemix_key.must_be :==, key
  end

  it 'allows you to set the alchemy key directly as array' do
    key = ['xxxxxxxx']
    AlchemyAPI.alchemy_key = key

    AlchemyAPI.alchemy_key.must_be :==, key.first
  end

  it 'allows you to set the bluemix key directly as array' do
    key = ['xxxxxxxx']
    AlchemyAPI.bluemix_key = key

    AlchemyAPI.bluemix_key.must_be :==, key.first
  end

  it 'round robin on array of key for alchemy key' do
    key = ['1','2','3']
    AlchemyAPI.alchemy_key = key

    key.map { |key| key.must_be :==, AlchemyAPI.alchemy_key }
    #moar tests
    (key.size * 100).times do |idx|
      key[idx % key.size].must_be :==, AlchemyAPI.alchemy_key
    end

  end

  it 'round robin on array of key for bluemix key' do
    key = ['1','2','3']
    AlchemyAPI.bluemix_key = key

    key.map { |key| key.must_be :==, AlchemyAPI.bluemix_key }

    #moar tests
    (key.size * 100).times do |idx|
      key[idx % key.size].must_be :==, AlchemyAPI.bluemix_key
    end

  end

  # todo multithread test?
  # it 'round robin on array of key with multithreads for bluemix key' do
  #   THREADS = 10
  #   KEY_REQUESTS = 100
  #   KEYS = [*0...(THREADS * KEY_REQUESTS)]
  #   AlchemyAPI.bluemix_key = KEYS
  #
  #   threads = []
  #   keys = []
  #   THREADS.times do |idx|
  #     threads << Thread.new do
  #       KEY_REQUESTS.times do
  #         keys << AlchemyAPI.bluemix_key
  #       end
  #     end
  #   end
  #   threads.each &:join
  #   keys.must_be :==, KEYS
  # end

  describe AlchemyAPI::Config do
    describe '.add_mode' do
      it 'allows classes to register themselves' do
        class Foo
          AlchemyAPI::Config.add_mode :foo, self
        end

        AlchemyAPI::Config.modes[:foo].must_be :==, Foo
      end
    end

    describe '.output_mode' do
      after do
        AlchemyAPI.configure do |config|
          config.output_mode = :json
        end
      end

      it 'allows output mode to be set' do
        AlchemyAPI.configure do |config|
          config.output_mode = :xml
        end

        AlchemyAPI.config.output_mode.must_be :==, :xml
      end

      it 'errors on invalid output mode' do
        lambda do
          AlchemyAPI.configure do |config|
            config.output_mode = :xls
          end
        end.must_raise AlchemyAPI::InvalidOutputMode
      end
    end
  end

  describe '.search' do
    it 'needs an api key' do
      AlchemyAPI::Config.apikey = nil

      lambda do
        AlchemyAPI.search(:keyword_extraction, text: 'foo')
      end.must_raise AlchemyAPI::InvalidAPIKey
    end

    it 'needs a valid mode' do
      AlchemyAPI::Config.apikey = 'xxxxxxxxxxx'

      lambda do
        AlchemyAPI.search(:bar, text: 'hello')
      end.must_raise AlchemyAPI::InvalidSearchMode
    end
  end
end
