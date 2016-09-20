require 'spec_helper'

describe ClubhouseRuby do
  it 'has a version number' do
    expect(ClubhouseRuby::VERSION).to_not be nil
  end

  it 'has a FORMATS constant defining acceptable reponse formats' do
    expect(ClubhouseRuby::FORMATS).to_not be nil
  end

  it 'has a METHODS constant defining acceptable request methods' do
    expect(ClubhouseRuby::METHODS).to_not be nil
  end

  it 'has a RESOURCES constant defining known api resources' do
    expect(ClubhouseRuby::RESOURCES).to_not be nil
  end

  it 'has an API_URL constant defining the base api url' do
    expect(ClubhouseRuby::API_URL).to_not be nil
  end
end
