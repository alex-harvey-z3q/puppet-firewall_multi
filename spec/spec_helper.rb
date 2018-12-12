# THIS FILE IS CENTRALLY MANAGED BY sync_spec.rb!
# DO NOT EDIT IT HERE!

# Without this, a warning is seen:
#
#   puppetlabs_spec_helper: defaults `mock_with` to `:mocha`.
#
# but the RSpec.configure needs to come before require
# puppetlabs_spec_helper.
#
RSpec.configure do |c|
  c.mock_with :mocha
end

require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-utils'

RSpec.configure do |c|
  c.formatter = :documentation
  c.tty       = true
  c.default_facts = {
    :ipaddress => '1.1.1.1',
  }
end
