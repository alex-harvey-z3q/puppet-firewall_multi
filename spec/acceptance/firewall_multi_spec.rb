# frozen_string_literal: true

require "spec_helper_acceptance"

describe "firewall_multi" do
  let(:manifest) do
    <<~PUPPET
      firewall_multi { '100 accept generated manifest smoke test':
        source => [
          '10.0.10.0/24',
          '10.0.12.0/24',
        ],
        dport  => '80',
        proto  => 'tcp',
        jump   => 'accept',
      }
    PUPPET
  end

  it "compiles the defined type on the target" do
    if targeting_localhost?
      File.write("/tmp/firewall_multi.pp", manifest)
      modulepath = File.expand_path("../fixtures/modules", __dir__)
      run_shell("HOME=/tmp puppet apply --noop --tags __compile_only --modulepath #{modulepath} /tmp/firewall_multi.pp")
    else
      write_file("/tmp/firewall_multi.pp", manifest)
      run_shell("HOME=/tmp puppet apply --noop --tags __compile_only /tmp/firewall_multi.pp")
    end
  end
end
