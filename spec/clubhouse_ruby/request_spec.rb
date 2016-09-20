require 'spec_helper'

describe ClubhouseRuby::Request do
  let(:call_obj) do
    ch = ClubhouseRuby::Clubhouse.new(ENV['API_TOKEN'])
    ch.stories(123).comments
  end

  context '.new' do
    it 'requires a call_object' do
      expect { described_class.new(nil, method: :Get) }.to raise_error(ArgumentError)
    end

    it 'requires a known method' do
      expect { described_class.new(call_obj, method: :foo) }.to raise_error(ArgumentError)
    end

    it 'returns a new Clubhouse::Request object if successful' do
      expect(described_class.new(call_obj, method: :Get)).to be_a(described_class)
    end
  end

  context '#fetch' do
    it 'makes the api call' do
      req = described_class.new(call_obj, method: :Get)

      expect(Net::HTTP).to receive(:start)

      req.fetch
    end

    context 'making some non-exhaustive examples of api calls i suppose' do
      let(:ch) { ClubhouseRuby::Clubhouse.new(ENV['API_TOKEN']) }

      it 'gets a list of epics', :vcr do
        response = ch.epics.list
        expect(response[:code]).to eq('200')
        expect(response[:status]).to eq('OK')
        expect(response[:content].first['id']).to eq(6)
      end

      it 'gets a specific epic', :vcr do
        response = ch.epics.get(id: 6)
        expect(response[:code]).to eq('200')
        expect(response[:status]).to eq('OK')
        expect(response[:content]['id']).to eq(6)
      end
    end
  end
end
