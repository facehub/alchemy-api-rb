require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe AlchemyAPI, 'image_tagging' do
  before do
    AlchemyAPI::Config.bluemix_apikey = API_KEY
  end

  subject { AlchemyAPI::ImageTagging.new }

  describe '#search' do
    {
      url: 'http://blog.caranddriver.com/wp-content/uploads/2017/01/2017-EC-Small-Cars-Honda-Civic-hatchback.jpg'
    }.each do |type, value|
      [:json].each do |output_mode|
        before do
          AlchemyAPI::Config.output_mode = output_mode
        end

        describe "#{type} search with #{output_mode} results" do
          it 'returns an array of results' do
            cassette_name = "image_tagging_basic_#{type}_#{output_mode}_search"
            VCR.use_cassette(cassette_name) do
              result = subject.search(type => value)
              result.must_be_instance_of Array
            end
          end

          it 'includes the keyword text and score' do
            cassette_name = "image_tagging_basic_#{type}_#{output_mode}_search"
            VCR.use_cassette(cassette_name) do
              result = subject.search(type => value)[0]

              result['class'].wont_be_nil
              result['score'].wont_be_nil
            end
          end
        end
      end
    end
  end
end
