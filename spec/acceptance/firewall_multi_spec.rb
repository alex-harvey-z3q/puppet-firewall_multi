require 'spec_helper_acceptance'

describe 'firewall_multi' do
  context 'puppet apply' do
    it 'is expected to apply and be idempotent' do
      pp = <<-EOS
firewall_multi { '100 allow http and https access':
  source => [
    '10.0.10.0/24',
    '10.0.12.0/24',
  ],
  destination => [
    '10.2.0.0/24',
    '10.3.0.0/24',
  ],
  dport  => [80, 443],
  proto  => tcp,
  action => accept,
}
EOS
      apply_manifest pp, :catch_failures => true
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
  end

  ['10.0.10.0/24', '10.0.12.0/24'].each do |source|
    ['10.2.0.0/24', '10.3.0.0/24'].each do |destination|

      rule = "-A INPUT -s #{source} -d #{destination}"

      describe iptables do
        it { is_expected.to have_rule(rule) }
      end

    end
  end

end
