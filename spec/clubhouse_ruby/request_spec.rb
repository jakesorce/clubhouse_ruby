require 'spec_helper'

describe ClubhouseRuby::Request do
  let(:new_clubhouse) { ClubhouseRuby::Clubhouse.new(ENV['API_TOKEN']) }

  describe '.new' do
    before(:example) do
      # Request requires the clubhouse object to have a path
      new_clubhouse.clear_path
      new_clubhouse.epics
    end

    it 'requires a clubhouse instance' do
      expect { described_class.new(nil, action: :Get) }.to raise_error(ArgumentError)
    end

    it 'requires a known action' do
      expect { described_class.new(new_clubhouse, action: :foo) }.to raise_error(ArgumentError)
    end

    it 'returns a new Clubhouse::Request object if successful' do
      expect(described_class.new(new_clubhouse, action: :Get)).to be_a(described_class)
    end
  end

  describe '#fetch' do
    it 'makes the api call' do
      clubhouse = new_clubhouse.epics
      req = described_class.new(clubhouse, action: :Get)

      expect(Net::HTTP).to receive(:start)

      req.fetch
    end

    context 'with, er, some non-exhaustive examples of api calls' do
      it 'lists all epics', :vcr do
        clubhouse = new_clubhouse.epics.list

        expect(clubhouse[:code]).to eq('200')
        expect(clubhouse[:status]).to eq('OK')
        expect(clubhouse[:content].first['id']).to eq(24)
        expect(clubhouse[:content].first['name']).to eq('My New Epic')
        expect(clubhouse[:content].last['id']).to eq(34)
        expect(clubhouse[:content].last['name']).to eq('EEEEEEPIC')
      end

      it 'gets an epic', :vcr do
        clubhouse = new_clubhouse.epics.get(id: 24)

        expect(clubhouse[:code]).to eq('200')
        expect(clubhouse[:status]).to eq('OK')
        expect(clubhouse[:content]['id']).to eq(24)
        expect(clubhouse[:content]['name']).to eq('My New Epic')
      end

      it 'creates an epic', :vcr do
        clubhouse = new_clubhouse.epics.create(name: 'EEEEEEPIC', state: 'to do')

        expect(clubhouse[:code]).to eq('201')
        expect(clubhouse[:status]).to eq('Created')
        expect(clubhouse[:content]['id']).to eq(38)
        expect(clubhouse[:content]['name']).to eq('EEEEEEPIC')
        expect(clubhouse[:content]['state']).to eq('to do')
      end

      it 'updates an epic', :vcr do
        clubhouse = new_clubhouse.epics.update(id: 24, state: 'in progress')

        expect(clubhouse[:code]).to eq('200')
        expect(clubhouse[:status]).to eq('OK')
        expect(clubhouse[:content]['state']).to eq('in progress')
      end

      it 'deletes an epic', :vcr do
        clubhouse = new_clubhouse.epics.delete(id: 24)

        expect(clubhouse[:code]).to eq('204')
        expect(clubhouse[:status]).to eq('No Content')
      end

      it 'reports errors for a missing epic', :vcr do
        clubhouse = new_clubhouse.epics.get(id: 666)

        expect(clubhouse[:code]).to eq('404')
        expect(clubhouse[:status]).to eq('Not Found')
        expect(clubhouse[:content]).to eq({"message"=>"Resource not found."})
      end

      it 'reports errors for bad params', :vcr do
        clubhouse = new_clubhouse.epics.create(foo: 'bar')

        expect(clubhouse[:code]).to eq('400')
        expect(clubhouse[:status]).to eq('Bad Request')
        expect(clubhouse[:content].key?("message")).to be true
        expect(clubhouse[:content].key?("errors")).to be true
      end

      it 'gets a project', :vcr do
        clubhouse = new_clubhouse.projects.get(id: 5)

        expect(clubhouse[:code]).to eq('200')
        expect(clubhouse[:status]).to eq('OK')
        expect(clubhouse[:content]['id']).to eq(5)
        expect(clubhouse[:content]['name']).to eq('Sweet Project')
      end

      it 'lists all stories for a project', :vcr do
        clubhouse = new_clubhouse.projects(5).stories.list

        expect(clubhouse[:code]).to eq('200')
        expect(clubhouse[:status]).to eq('OK')
        expect(clubhouse[:content].count).to eq(12)
        expect(clubhouse[:content].first['id']).to eq(20)
        expect(clubhouse[:content].first['name']).to eq('Reap Rewards')
      end

      it 'creates multiple stories', :vcr do
        new_stories = [
          { project_id: 5, name: "Once Upon" },
          { project_id: 5, name: "A Time" },
          { project_id: 5, name: "In A Land" }
        ]
        clubhouse = new_clubhouse.stories.bulk_create(stories: new_stories)

        expect(clubhouse[:code]).to eq('201')
        expect(clubhouse[:status]).to eq('Created')
        expect(clubhouse[:content].count).to eq(3)
        expect(clubhouse[:content].first['id']).to eq(39)
        expect(clubhouse[:content].first['name']).to eq('Once Upon')
      end

      it 'updates multiple stories', :vcr do
        params = {
          story_ids: [29, 30],
          archived: true
        }
        clubhouse = new_clubhouse.stories.bulk_update(params)

        expect(clubhouse[:code]).to eq('200')
        expect(clubhouse[:status]).to eq('OK')
        expect(clubhouse[:content].count).to eq(2)
        expect(clubhouse[:content].first['id']).to eq(29)
        expect(clubhouse[:content].first['archived']).to eq(true)
      end

      it 'searches stories', :vcr do
        params = {
          query: '!is:archived ',
          page_size: 5
        }
        clubhouse = new_clubhouse.search_stories(params)

        expect(clubhouse[:code]).to eq('200')
        expect(clubhouse[:status]).to eq('OK')
        expect(clubhouse[:content]['data'].count).to eq(5)
        expect(clubhouse[:content]['data'].first['id']).to eq(32)
        expect(clubhouse[:content]['data'].first['archived']).to eq(false)
      end
    end
  end
end
