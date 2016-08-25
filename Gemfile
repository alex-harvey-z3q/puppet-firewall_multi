source 'https://rubygems.org'

group :tests do
  gem 'puppetlabs_spec_helper', '~>1.1.0', :require => false
  #gem 'nokogiri', '< 1.6.8'
end

group :system_tests do
  gem 'beaker',       :require => false
  gem 'beaker-rspec', :require => false
  gem 'beaker-puppet_install_helper', :require => false
end

gem 'facter'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# https://tickets.puppetlabs.com/browse/PUP-6551
#
# json_pure 2.0.2 added a requirement on ruby >= 2. We pin to json_pure 2.0.1
# if using ruby 1.x for puppet 3.2 through puppet 3.4
gem 'json_pure', '<=2.0.1', :require => false if RUBY_VERSION =~ /^1\./
