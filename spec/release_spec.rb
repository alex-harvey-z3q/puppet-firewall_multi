# THIS FILE IS CENTRALLY MANAGED BY sync_spec.rb!
# DO NOT EDIT IT HERE!

require "spec_helper"
require "json"
require "erb"

metadata = JSON.parse(File.read("metadata.json"))
fm_version = metadata["version"]
fw_version = metadata["dependencies"][0]["version_requirement"]

# https://unix.stackexchange.com/a/283489/231569
latest = `gsed -n '
  /## Version compatibility/ {
    N
    N
    N
  }
  /## Setup/!N
  /.*\\n.*\\n.*\\n.*\\n.*## Setup.*/P  # Backslash escaped to protect from Ruby.
  D
' README.md`.chomp

expected_fm, expected_fw = latest.split("|")

describe "Release-related checks" do
  it "Version in metadata.json should match a tag - are you about to tag & release? If so, ignore." do
    expect(`git tag --sort=-creatordate | head -1`.chomp).to eq fm_version
  end

  it "versions of this module in metadata.json should match those in the version matrix" do
    expect(fm_version).to eq expected_fm
  end

  it "versions of upstream module in metadata.json should match those in the version matrix" do
    expect(fw_version).to eq expected_fw
  end

  it "First line of CHANGELOG should mention the version - did you forget to update CHANGELOG?" do
    expect(`head -1 CHANGELOG`).to match %r{#{fm_version}}
  end

  it "README should mention the version" do
    expect(`grep ^#{fm_version} README.md`).to match %r{#{fm_version}\|\d+\.\d+\.\d+}
  end

  it ".README.erb should generate README.md" do
    template = File.read(".README.erb")
    readme = File.read("README.md")
    renderer = ERB.new(template, nil, "-")
    expect(readme).to eq renderer.result
  end
end
