require 'spec_helper'

describe ClubhouseRuby::Request do
  API_TOKEN = "MY CLUBHOUSE API TOKEN".freeze
  let(:call_obj) do
    ch = ClubhouseRuby::Clubhouse.new(API_TOKEN)
    ch.stories(123).comments
  end

  context ".new" do
    it 'requires a call_object' do
      expect { described_class.new(nil, method: :get) }.to raise_error(ArgumentError)
    end

    it 'requires a known method' do
      expect { described_class.new(call_obj, method: :foo) }.to raise_error(ArgumentError)
    end
    it 'returns a new Clubhouse::Request object if successful' do
      expect(described_class.new(call_obj, method: :get)).to be_a(described_class)
    end
  end

  context "#fetch" do
    #TODO: test this somehow - use vcr?
  end
end
