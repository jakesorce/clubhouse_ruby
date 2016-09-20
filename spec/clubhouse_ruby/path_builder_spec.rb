require 'spec_helper'

describe ClubhouseRuby::PathBuilder do
  API_TOKEN = "MY CLUBHOUSE API TOKEN".freeze
  let(:call_obj) { ClubhouseRuby::Clubhouse.new(API_TOKEN) }

  before(:example) do
    call_obj.clear_path
  end

  it 'allows you to build a path to a known resource' do
    resource = ClubhouseRuby::RESOURCES.sample
    result = call_obj.send(resource)
    expect(result).to be_a(ClubhouseRuby::Clubhouse)
    expect(result.path).to eq([resource])
  end

  it 'allows you to add an id to a nested resources parent' do
    resource = ClubhouseRuby::RESOURCES.sample
    id = rand(10000)
    result = call_obj.send(resource, id)
    expect(result).to be_a(ClubhouseRuby::Clubhouse)
    expect(result.path).to eq([resource, id])
  end

  it 'allows you to clear a partially built path' do
    resource = ClubhouseRuby::RESOURCES.sample
    result = call_obj.send(resource)
    result.clear_path
    expect(result.path).to eq([])
  end

  it 'recognizes and executes known methods, ending the path' do
    resource = ClubhouseRuby::RESOURCES.sample
    result = call_obj.send(resource)
    method = ClubhouseRuby::METHODS.keys.sample

    expect(Net::HTTP).to receive(:start)

    result.send(method)

    expect(result.path).to eq([])
  end

  it 'responds to known methods' do
    method = ClubhouseRuby::METHODS.keys.sample
    expect(call_obj.respond_to?(method)).to be true
  end

  it 'responds to known resources' do
    resource = ClubhouseRuby::RESOURCES.sample
    expect(call_obj.respond_to?(resource)).to be true
  end

  it 'raises an ArgumentError for unrecognized paths' do
    expect { call_obj.send(:foo) }.to raise_error(NoMethodError)
  end
end
