require 'spec_helper'

describe ClubhouseRuby::PathBuilder do
  let(:new_clubhouse) { ClubhouseRuby::Clubhouse.new(ENV['API_TOKEN']) }

  # since not every example results in an action, we need to clean the path 
  before(:example) do
    new_clubhouse.clear_path
  end

  it 'allows you to build a path to a known resource' do
    resource = ClubhouseRuby::RESOURCES.sample
    clubhouse = new_clubhouse.send(resource)

    expect(clubhouse).to be_a(ClubhouseRuby::Clubhouse)
    expect(clubhouse.path).to eq([resource])
  end

  it 'allows you to add an id to a nested resources parent' do
    resource = ClubhouseRuby::RESOURCES.sample
    id = rand(10000)
    clubhouse = new_clubhouse.send(resource, id)

    expect(clubhouse).to be_a(ClubhouseRuby::Clubhouse)
    expect(clubhouse.path).to eq([resource, id])
  end

  it 'allows you to clear a partially built path' do
    resource = ClubhouseRuby::RESOURCES.sample
    clubhouse = new_clubhouse.send(resource)
    clubhouse.clear_path

    expect(clubhouse.path).to eq([])
  end

  it 'recognizes and executes known actions, clearing the path' do
    resource = ClubhouseRuby::RESOURCES.sample
    action = ClubhouseRuby::ACTIONS.keys.sample
    clubhouse = new_clubhouse.send(resource)

    expect(Net::HTTP).to receive(:start)

    clubhouse.send(action)

    expect(clubhouse.path).to eq([])
  end

  it 'recognizes known exceptions, builds the path, then executes' do
    resource = ClubhouseRuby::RESOURCES.sample
    exception = ClubhouseRuby::EXCEPTIONS.keys.sample
    clubhouse = new_clubhouse.send(resource)

    expect(Net::HTTP).to receive(:start)

    clubhouse.send(exception)

    expect(clubhouse.path).to eq([])
  end

  it 'responds to known actions' do
    action = ClubhouseRuby::ACTIONS.keys.sample

    expect(new_clubhouse.respond_to?(action)).to be true
  end

  it 'responds to known resources' do
    resource = ClubhouseRuby::RESOURCES.sample
    expect(new_clubhouse.respond_to?(resource)).to be true
  end

  it 'responds to known exceptions' do
    resource = ClubhouseRuby::EXCEPTIONS.keys.sample
    expect(new_clubhouse.respond_to?(resource)).to be true
  end

  it 'raises an ArgumentError for unrecognized paths' do
    expect { new_clubhouse.send(:foo) }.to raise_error(NoMethodError)
  end
end
