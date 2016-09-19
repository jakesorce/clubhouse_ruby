require 'spec_helper'

describe ClubhouseRuby::Request do
  API_TOKEN = "MY CLUBHOUSE API TOKEN".freeze

  context ".new" do
    let(:params) do
      {
        path: ["stories", 123, "comments"],
        method: :get,
        token: API_TOKEN
      }
    end

    it 'requires a path' do
      expect {
        described_class.new(params.replace(path: nil))
      }.to raise_error(ArgumentError)
    end

    it 'requires a known method' do
      expect {
        described_class.new(params.replace(method: "foo"))
      }.to raise_error(ArgumentError)
    end

    it 'requires a token' do
      expect {
        described_class.new(params.replace(token: nil))
      }.to raise_error(ArgumentError)
    end

    it 'returns a new Clubhouse::Request object if successful' do
      expect(described_class.new(params)).to be_a described_class
    end
  end
end
