# THIS FILE IS CENTRALLY MANAGED BY sync_spec.rb!
# DO NOT EDIT IT HERE!

require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-utils'

RSpec.configure do |c|
  c.formatter = :documentation
  c.tty       = true
  c.default_facts = {
    :ipaddress => '1.1.1.1',
  }
end
