require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    hosts.each do |host|
      copy_module_to(host, :source => proj_root, :module_name => 'firewall_multi')
      on host, puppet('module install puppetlabs-firewall'), {:acceptable_exit_codes => [0,1]}

      # https://tickets.puppetlabs.com/browse/MODULES-3153
      if os[:family] == 'redhat' and os[:release] == '7'
        on host, 'yum -y install iptables-services'
        on host, 'systemctl start iptables.service'
      end
    end
  end
end
