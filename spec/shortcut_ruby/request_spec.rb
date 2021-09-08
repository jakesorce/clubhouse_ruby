require 'spec_helper'

describe ShortcutRuby::Request do
  let(:new_shortcut) { ShortcutRuby::Shortcut.new(ENV['API_TOKEN']) }

  describe '.new' do
    before(:example) do
      # Request requires the shortcut object to have a path
      new_shortcut.clear_path
      new_shortcut.epics
    end

    it 'requires a shortcut instance' do
      expect { described_class.new(nil, action: :Get) }.to raise_error(ArgumentError)
    end

    it 'requires a known action' do
      expect { described_class.new(new_shortcut, action: :foo) }.to raise_error(ArgumentError)
    end

    it 'returns a new Shortcut::Request object if successful' do
      expect(described_class.new(new_shortcut, action: :Get)).to be_a(described_class)
    end
  end

  describe '#fetch' do
    it 'makes the api call' do
      shortcut = new_shortcut.epics
      req = described_class.new(shortcut, action: :Get)

      expect(Net::HTTP).to receive(:start)

      req.fetch
    end

    context 'with, er, some non-exhaustive examples of api calls' do
      it 'lists all epics', :vcr do
        shortcut = new_shortcut.epics.list

        expect(shortcut[:code]).to eq('200')
        expect(shortcut[:status]).to eq('OK')
        expect(shortcut[:content].first['id']).to eq(25)
        expect(shortcut[:content].first['name']).to eq('EEEEEEPIC')
        expect(shortcut[:content].last['id']).to eq(33)
        expect(shortcut[:content].last['name']).to eq('new test epic')
      end

      it 'gets an epic', :vcr do
        shortcut = new_shortcut.epics.get(id: 25)

        expect(shortcut[:code]).to eq('200')
        expect(shortcut[:status]).to eq('OK')
        expect(shortcut[:content]['id']).to eq(25)
        expect(shortcut[:content]['name']).to eq('EEEEEEPIC')
      end

      it 'creates an epic', :vcr do
        shortcut = new_shortcut.epics.create(name: 'A new test epic', state: 'to do')

        expect(shortcut[:code]).to eq('201')
        expect(shortcut[:status]).to eq('Created')
        expect(shortcut[:content]['id']).to eq(52)
        expect(shortcut[:content]['name']).to eq('A new test epic')
        expect(shortcut[:content]['state']).to eq('to do')
      end

      it 'updates an epic', :vcr do
        shortcut = new_shortcut.epics.update(id: 25, state: 'in progress')

        expect(shortcut[:code]).to eq('200')
        expect(shortcut[:status]).to eq('OK')
        expect(shortcut[:content]['state']).to eq('in progress')
      end

      it 'deletes an epic', :vcr do
        shortcut = new_shortcut.epics.delete(id: 25)

        expect(shortcut[:code]).to eq('204')
        expect(shortcut[:status]).to eq('No Content')
      end

      it 'reports errors for a missing epic', :vcr do
        shortcut = new_shortcut.epics.get(id: 25)

        expect(shortcut[:code]).to eq('404')
        expect(shortcut[:status]).to eq('Not Found')
        expect(shortcut[:content]).to eq({"message"=>"Resource not found."})
      end

      it 'reports errors for bad params', :vcr do
        shortcut = new_shortcut.epics.create(foo: 'bar')

        expect(shortcut[:code]).to eq('400')
        expect(shortcut[:status]).to eq('Bad Request')
        expect(shortcut[:content].key?("message")).to be true
        expect(shortcut[:content].key?("errors")).to be true
      end

      it 'gets a project', :vcr do
        shortcut = new_shortcut.projects.get(id: 5)

        expect(shortcut[:code]).to eq('200')
        expect(shortcut[:status]).to eq('OK')
        expect(shortcut[:content]['id']).to eq(5)
        expect(shortcut[:content]['name']).to eq('Sweet Project')
      end

      it 'lists all stories for a project', :vcr do
        shortcut = new_shortcut.projects(5).stories.list

        expect(shortcut[:code]).to eq('200')
        expect(shortcut[:status]).to eq('OK')
        expect(shortcut[:content].count).to eq(3)
        expect(shortcut[:content].first['id']).to eq(20)
        expect(shortcut[:content].first['name']).to eq('Reap Rewards')
      end

      it 'creates multiple stories', :vcr do
        new_stories = [
          { project_id: 4, name: "Some new" },
          { project_id: 4, name: "Test stories" },
          { project_id: 4, name: "That exist" }
        ]
        shortcut = new_shortcut.stories.bulk_create(stories: new_stories)

        expect(shortcut[:code]).to eq('201')
        expect(shortcut[:status]).to eq('Created')
        expect(shortcut[:content].count).to eq(3)
        expect(shortcut[:content].first['id']).to eq(56)
        expect(shortcut[:content].first['name']).to eq('Some new')
      end

      it 'updates multiple stories', :vcr do
        params = {
          story_ids: [8, 15],
          archived: true
        }
        shortcut = new_shortcut.stories.bulk_update(params)

        expect(shortcut[:code]).to eq('200')
        expect(shortcut[:status]).to eq('OK')
        expect(shortcut[:content].count).to eq(2)
        expect(shortcut[:content].first['id']).to eq(15)
        expect(shortcut[:content].first['archived']).to eq(true)
      end

      it 'searches stories', :vcr do
        params = {
          query: '!is:archived ',
          page_size: 5
        }
        shortcut = new_shortcut.search_stories(params)

        expect(shortcut[:code]).to eq('200')
        expect(shortcut[:status]).to eq('OK')
        expect(shortcut[:content]['data'].count).to eq(3)
        expect(shortcut[:content]['data'].first['id']).to eq(20)
        expect(shortcut[:content]['data'].first['archived']).to eq(false)
      end
    end
  end
end

