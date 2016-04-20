require 'spec_helper'

describe 'firewall_multi' do

  # while it doesn't make sense to pass all these parameters
  # into a firewall type we are testing the expected behaviour
  # of our multiplexer.

  # we have made a deliberate design decision NOT to do input
  # sanity checking in this module, but leave that to the 
  # firewall resource type.

  context 'an array for all inputs that accept arrays' do
    sources = [
      '1.1.1.1/24',
      '2.2.2.2/24',
    ]
    destinations = [
      '3.3.3.3/24',
      '4.4.4.4/24',
    ]
    icmps = ['0', '8']
    let(:title) { '00100 accept on port 80' }
    let(:params) {{
      'action' => 'accept',
      'dport'  => '80',
      'proto'  => 'tcp',
      'source'      => sources,
      'destination' => destinations,
      'icmp'        => icmps,
    }}
    sources.each do |s|
      destinations.each do |d|
        icmps.each do |i|
          it {
            is_expected.to contain_firewall("00100 accept on port 80 from #{s} to #{d} icmp type #{i}").with(
              'action' => 'accept',
              'dport'  => '80',
              'proto'  => 'tcp',
              'source'      => s,
              'destination' => d,
              'icmp'        => i,
            )
          }
        end
      end
    end
  end

  context 'an array of sources and a single destination' do
    sources = [
      '1.1.1.1/24',
      '2.2.2.2/24',
    ]
    source      = '1.1.1.1/24'
    destination = '3.3.3.3/24'
    let(:title) { '00100 accept on port 80' }
    let(:params) {{
      'action' => 'accept',
      'dport'  => '80',
      'proto'  => 'tcp',
      'source'      => sources,
      'destination' => destination,
    }}
    it {
      is_expected.to contain_firewall("00100 accept on port 80 from #{source}").with(
        'action' => 'accept',
        'dport'  => '80',
        'proto'  => 'tcp',
        'source'      => source,
        'destination' => destination,
      )
    }
  end

  context 'an array of sources and no destination' do
    sources = [
      '1.1.1.1/24',
      '2.2.2.2/24',
    ]
    source = '1.1.1.1/24'
    let(:title) { '00100 accept on port 80' }
    let(:params) {{
      'action' => 'accept',
      'dport'  => '80',
      'proto'  => 'tcp',
      'source' => sources,
    }}
    it {
      is_expected.to contain_firewall("00100 accept on port 80 from #{source}").with(
        'action' => 'accept',
        'dport'  => '80',
        'proto'  => 'tcp',
        'source' => source,
      )
    }
  end

  context 'an array of destinations and no source' do
    destinations = [
      '3.3.3.3/24',
      '4.4.4.4/24',
    ]
    let(:title) { '00100 accept on port 80' }
    let(:params) {{
      'action' => 'accept',
      'dport'  => '80',
      'proto'  => 'tcp',
      'destination' => destinations,
    }}
    it {
      is_expected.to contain_firewall('00100 accept on port 80 to 4.4.4.4/24').with(
        'action' => 'accept',
        'dport'  => '80',
        'proto'  => 'tcp',
        'destination' => '4.4.4.4/24',
      )
    }
  end

  context 'an array of destinations with a single source' do
    destinations = [
      '3.3.3.3/24',
      '4.4.4.4/24',
    ]
    source      = '1.1.1.1/24'
    destination = '3.3.3.3/24'
    let(:title) { '00100 accept on port 80' }
    let(:params) {{
      'action' => 'accept',
      'dport'  => '80',
      'proto'  => 'tcp',
      'source'      => source,
      'destination' => destinations,
    }}
    it {
      is_expected.to contain_firewall("00100 accept on port 80 to #{destination}").with(
        'action' => 'accept',
        'dport'  => '80',
        'proto'  => 'tcp',
        'source'      => source,
        'destination' => destination,
      )
    }
  end

  context 'an array of protocols' do
    protocols = [
      'tcp',
      'udp',
    ]
    let(:title) { '00100 accept on port 53' }
    let(:params) {{
      'action' => 'accept',
      'dport'  => '53',
      'proto'  => protocols,
    }}
    protocols.each do |protocol|
      it {
        is_expected.to contain_firewall("00100 accept on port 53 protocol #{protocol}").with(
          'action' => 'accept',
          'dport'  => '53',
          'proto'  => protocol,
        )
      }
    end
  end

  context 'an array of icmp' do
    icmps = ['0', '8']
    let(:title) { '00100 accept output' }
    let(:params) {{
      'chain'  => 'OUTPUT',
      'proto'  => 'icmp',
      'action' => 'accept',
      'icmp'   => icmps,
    }}
    icmps.each do |i|
      it {
        is_expected.to contain_firewall("00100 accept output icmp type #{i}").with(
          'chain'  => 'OUTPUT',
          'proto'  => 'icmp',
          'action' => 'accept',
          'icmp'   => i,
        )
      }
    end
  end

  context 'an array of icmp as integers' do
    icmps = [0, 8]
    let(:title) { '00100 accept output' }
    let(:params) {{
      'chain'  => 'OUTPUT',
      'proto'  => 'icmp',
      'action' => 'accept',
      'icmp'   => icmps,
    }}
    it {
      is_expected.to contain_firewall('00100 accept output icmp type 8').with(
        'chain'  => 'OUTPUT',
        'proto'  => 'icmp',
        'action' => 'accept',
        'icmp'   => '8',
      )
    }
  end

  # if none of our allowed array inputs are passed then a firewall_multi should
  # spawn one identical firewall resource.

  context 'neither a source nor destination' do
    let(:title) { '00100 accept on port 80' }
    let(:params) {{
      'action' => 'accept',
      'dport'  => '80',
      'proto'  => 'tcp',
    }}
    it {
      is_expected.to contain_firewall('00100 accept on port 80').with(
        'action' => 'accept',
        'dport'  => '80',
        'proto'  => 'tcp',
      )
    }
  end

  context 'passes dst_range through' do
    sources = [
      '1.1.1.1/24',
      '2.2.2.2/24',
    ]
    dst_range = '3.3.3.3-3.3.3.10'
    let(:title) { '00100 accept on port 80' }
    let(:params) {{
      'action' => 'accept',
      'dport'  => '80',
      'proto'  => 'tcp',
      'source' => sources,
      'dst_range' => dst_range,
    }}
    it {
      is_expected.to contain_firewall('00100 accept on port 80 from 1.1.1.1/24').with(
        'action' => 'accept',
        'dport'  => '80',
        'proto'  => 'tcp',
        'source' => '1.1.1.1/24',
        'dst_range' => dst_range,
      )
    }
  end
end
