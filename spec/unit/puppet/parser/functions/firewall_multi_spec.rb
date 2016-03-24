require 'spec_helper'

describe Puppet::Parser::Functions.function(:firewall_multi) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('firewall_multi')).to eq 'function_firewall_multi'
  end

  context 'when given a wrong number of arguments' do
    it 'should fail' do
      expect {
        scope.function_firewall_multi([])
      }.to raise_error ArgumentError, /Wrong number of arguments given/
    end
  end

  context 'when given the wrong type of arguments' do
    it 'should fail' do
      expect {
        scope.function_firewall_multi([['I_am_not_a_string'], {}])
      }.to raise_error ArgumentError, /first argument must be a string/
    end

    it 'should fail' do
      expect {
        scope.function_firewall_multi(['I_am_a_string', 'but_I_am_not_a_hash'])
      }.to raise_error ArgumentError, /second argument must be a hash/
    end
  end

  context 'correctly parses a hash' do
    input = [
      '00100 accept inbound ssh',
      {
        'action' => 'accept',
        'source' => ['1.1.1.1/24', '2.2.2.2/24'],
        'dport'  => 22,
      },
    ]

    output = {
      '00100 accept inbound ssh from 1.1.1.1/24' => {
        'action' => 'accept',
        'source' => '1.1.1.1/24',
        'dport'  => 22,
      },
      '00100 accept inbound ssh from 2.2.2.2/24' => {
        'action' => 'accept',
        'source' => '2.2.2.2/24',
        'dport'  => 22,
      },
    }

    it 'should convert hash into expected format' do
      expect(scope.function_firewall_multi(input)).to eq output
    end
  end
end

