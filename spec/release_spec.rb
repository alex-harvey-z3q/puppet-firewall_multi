# THIS FILE IS CENTRALLY MANAGED BY sync_spec.rb!
# DO NOT EDIT IT HERE!

require 'spec_helper'
require 'json'

version = JSON.parse(File.read('metadata.json'))['version']

describe 'Release-related checks' do
  it 'Version in metadata.json should match a tag' do
    expect(%x{git tag --sort=-creatordate | head -1}.chomp).to eq version
  end

  it 'First line of CHANGELOG should mention the version' do
    expect(%x{head -1 CHANGELOG}).to match /#{version}/
  end

  it 'README should mention the version' do
    expect(%x{grep ^#{version} README.md}).to match /#{version}\|\d+\.\d+\.\d+/
  end
end
