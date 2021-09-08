require 'spec_helper'

describe ShortcutRuby::PathBuilder do
  let(:new_shortcut) { ShortcutRuby::Shortcut.new(ENV['API_TOKEN']) }

  # since not every example results in an action, we need to clean the path
  before(:example) do
    new_shortcut.clear_path
  end

  it 'allows you to build a path to a known resource' do
    resource = ShortcutRuby::RESOURCES.sample
    shortcut = new_shortcut.send(resource)

    expect(shortcut).to be_a(ShortcutRuby::Shortcut)
    expect(shortcut.path).to eq([resource])
  end

  it 'allows you to add an id to a nested resources parent' do
    resource = ShortcutRuby::RESOURCES.sample
    id = rand(10000)
    shortcut = new_shortcut.send(resource, id)

    expect(shortcut).to be_a(ShortcutRuby::Shortcut)
    expect(shortcut.path).to eq([resource, id])
  end

  it 'allows you to clear a partially built path' do
    resource = ShortcutRuby::RESOURCES.sample
    shortcut = new_shortcut.send(resource)
    shortcut.clear_path

    expect(shortcut.path).to eq([])
  end

  it 'recognizes and executes known actions, clearing the path' do
    resource = ShortcutRuby::RESOURCES.sample
    action = ShortcutRuby::ACTIONS.keys.sample
    shortcut = new_shortcut.send(resource)

    expect(Net::HTTP).to receive(:start)

    shortcut.send(action)

    expect(shortcut.path).to eq([])
  end

  it 'recognizes known exceptions, builds the path, then executes' do
    resource = ShortcutRuby::RESOURCES.sample
    exception = ShortcutRuby::EXCEPTIONS.keys.sample
    shortcut = new_shortcut.send(resource)

    expect(Net::HTTP).to receive(:start)

    shortcut.send(exception)

    expect(shortcut.path).to eq([])
  end

  it 'responds to known actions' do
    action = ShortcutRuby::ACTIONS.keys.sample

    expect(new_shortcut.respond_to?(action)).to be true
  end

  it 'responds to known resources' do
    resource = ShortcutRuby::RESOURCES.sample
    expect(new_shortcut.respond_to?(resource)).to be true
  end

  it 'responds to known exceptions' do
    resource = ShortcutRuby::EXCEPTIONS.keys.sample
    expect(new_shortcut.respond_to?(resource)).to be true
  end

  it 'raises an ArgumentError for unrecognized paths' do
    expect { new_shortcut.send(:foo) }.to raise_error(NoMethodError)
  end
end
