require 'spec_helper'

describe 'firewall_multi' do
  context 'an array of both sources and destinations' do
    sources = [
      '1.1.1.1/24',
      '2.2.2.2/24',
    ]
    destinations = [
      '3.3.3.3/24',
      '4.4.4.4/24',
    ]
    let(:title) { '00100 accept on port 80' }
    let(:params) {{
      'action' => 'accept',
      'dport'  => '80',
      'proto'  => 'tcp',
      'source'      => sources,
      'destination' => destinations,
    }}
    sources.each do |s|
      destinations.each do |d|
        it {
          is_expected.to contain_firewall("00100 accept on port 80 from #{s} to #{d}").with(
            'action' => 'accept',
            'dport'  => '80',
            'proto'  => 'tcp',
            'source'      => s,
            'destination' => d,
          )
        }
      end
    end
  end

  context 'an array of sources and a single destination' do
    sources = [
      '1.1.1.1/24',
      '2.2.2.2/24',
    ]
    destination = '3.3.3.3/24'
    let(:title) { '00100 accept on port 80' }
    let(:params) {{
      'action' => 'accept',
      'dport'  => '80',
      'proto'  => 'tcp',
      'source'      => sources,
      'destination' => destination,
    }}
    sources.each do |s|
      it {
        is_expected.to contain_firewall("00100 accept on port 80 from #{s} to #{destination}").with(
          'action' => 'accept',
          'dport'  => '80',
          'proto'  => 'tcp',
          'source'      => s,
          'destination' => destination,
        )
      }
    end
  end

  context 'an array of destinations with a single source' do
    source = '1.1.1.1/24'
    destinations = [
      '3.3.3.3/24',
      '4.4.4.4/24',
    ]
    let(:title) { '00100 accept on port 80' }
    let(:params) {{
      'action' => 'accept',
      'dport'  => '80',
      'proto'  => 'tcp',
      'source'      => source,
      'destination' => destinations,
    }}
    destinations.each do |d|
      it {
        is_expected.to contain_firewall("00100 accept on port 80 from #{source} to #{d}").with(
          'action' => 'accept',
          'dport'  => '80',
          'proto'  => 'tcp',
          'source'      => source,
          'destination' => d,
        )
      }
    end
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
      'source'    => sources,
      'dst_range' => dst_range,
    }}
    it {
      is_expected.to contain_firewall("00100 accept on port 80 from 1.1.1.1/24 to 0.0.0.0/0").with(
        'action' => 'accept',
        'dport'  => '80',
        'proto'  => 'tcp',
        'source'      => '1.1.1.1/24',
        'destination' => '0.0.0.0/0',
        'dst_range'   => dst_range,
      )
    }
  end
end
