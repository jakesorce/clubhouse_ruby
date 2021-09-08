require 'spec_helper'

describe ShortcutRuby do
  it 'has a version number' do
    expect(ShortcutRuby::VERSION).to_not be nil
  end

  it 'has a FORMATS constant defining acceptable reponse formats' do
    expect(ShortcutRuby::FORMATS).to_not be nil
  end

  it 'has an ACTIONS constant defining acceptable request actions' do
    expect(ShortcutRuby::ACTIONS).to_not be nil
  end

  it 'has a RESOURCES constant defining known api resources' do
    expect(ShortcutRuby::RESOURCES).to_not be nil
  end

  it 'has an annoying EXCEPTIONS constant defining known api exceptions' do
    expect(ShortcutRuby::EXCEPTIONS).to_not be nil
  end

  it 'has an API_URL constant defining the base api url' do
    expect(ShortcutRuby::API_URL).to_not be nil
  end
end
