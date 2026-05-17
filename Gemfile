# THIS FILE IS CENTRALLY MANAGED BY sync_spec.rb!
# DO NOT EDIT IT HERE!

source "https://rubygems.org"

group :tests do
  gem "puppetlabs_spec_helper", ">= 8.0.0", :require => false
  gem "rspec-puppet-utils", :require => false
  gem "metadata-json-lint", :require => false
  gem "puppet-blacksmith",  :require => false
  gem "puppet-strings", ">= 4.1.3", :require => false
  gem "CFPropertyList",  :require => false
  gem "rubocop-rspec",   :require => false
  gem "rubocop",         :require => false
end

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.1.0")
  group :acceptance do
    gem "puppet_litmus", "~> 2.0", :require => false
    gem "serverspec", :require => false
  end
end

if puppetversion = ENV["PUPPET_GEM_VERSION"]
  gem "puppet", puppetversion, :require => false
else
  gem "puppet", :require => false
end
