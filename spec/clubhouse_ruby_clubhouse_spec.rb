require 'spec_helper'

describe ClubhouseRuby::Clubhouse do
  API_TOKEN = "MY CLUBHOUSE API TOKEN".freeze

  it 'requires an authentication token' do
    expect { described_class.new }.to raise_error(ArgumentError)
    expect { described_class.new(API_TOKEN) }.to_not raise_error
  end

  it 'sets default response_format to json' do
    expect(described_class.new(API_TOKEN)).to have_attributes(response_format: "application/json")
  end

  it 'accepts response_format of "text/csv"' do
    expect(described_class.new(API_TOKEN, response_format: "text/csv")).to have_attributes(response_format: "text/csv")
  end

  it 'does not accept unknown response_formats' do
    expect { described_class.new(API_TOKEN, response_format: "text/xml") }.to raise_error(ArgumentError)
    expect { described_class.new(API_TOKEN, response_format: "foo/bar") }.to raise_error(ArgumentError)
  end
end
