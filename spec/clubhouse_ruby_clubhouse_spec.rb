require 'spec_helper'

describe ClubhouseRuby::Clubhouse do
  describe ".new" do
    it 'requires an authentication token' do
      expect { described_class.new }.to raise_error(ArgumentError)
      expect { described_class.new(ENV['API_TOKEN']) }.to_not raise_error
    end

    it 'sets default response_format to :json' do
      expect(described_class.new(ENV['API_TOKEN'])).to have_attributes(response_format: :json)
    end

    it 'accepts response_format of :csv' do
      expect(described_class.new(ENV['API_TOKEN'], response_format: :csv)).to have_attributes(response_format: :csv)
    end

    it 'does not accept unknown response_formats' do
      expect { described_class.new(ENV['API_TOKEN'], response_format: :xml) }.to raise_error(ArgumentError)
      expect { described_class.new(ENV['API_TOKEN'], response_format: :foo) }.to raise_error(ArgumentError)
    end
  end
end
