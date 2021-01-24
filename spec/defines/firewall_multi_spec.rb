require "spec_helper"

describe "firewall_multi" do
  # while it doesn"t make sense to pass all these parameters
  # into a firewall type we are testing the expected behaviour
  # of our multiplexer.

  # we have made a deliberate design decision NOT to do input
  # sanity checking in this module, but leave that to the
  # firewall resource type.

  context "when an array for all inputs that accept arrays" do
    sources = %w[
      1.1.1.1/24
      2.2.2.2/24
    ]
    destinations = %w[
      3.3.3.3/24
      4.4.4.4/24
    ]
    icmps = %w[0 8]

    let(:title) { "00100 accept on port 80" }
    let(:params) do
      {
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "source"      => sources,
        "destination" => destinations,
        "icmp"        => icmps
      }
    end

    sources.each do |source|
      destinations.each do |dest|
        icmps.each do |icmp|
          it {
            is_expected.to contain_firewall(
              "00100 accept on port 80 from #{source} to #{dest} icmp type #{icmp}"
            ).with(
              "action" => "accept",
              "dport"  => "80",
              "proto"  => "tcp",
              "source"      => source,
              "destination" => dest,
              "icmp"        => icmp
            )
          }
        end
      end
    end
  end

  context "when an array of sources and a single destination" do
    sources = %w[
      1.1.1.1/24
      2.2.2.2/24
    ]
    destination = "3.3.3.3/24"

    let(:title) { "00100 accept on port 80" }
    let(:params) do
      {
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "source"      => sources,
        "destination" => destination
      }
    end

    it do
      sources.each do |source|
        is_expected.to contain_firewall(
          "00100 accept on port 80 from #{source}"
        ).with(
          "action" => "accept",
          "dport"  => "80",
          "proto"  => "tcp",
          "source"      => source,
          "destination" => destination
        )
      end
    end
  end

  context "when an array of sources and no destination" do
    sources = %w[
      1.1.1.1/24
      2.2.2.2/24
    ]
    source = "1.1.1.1/24"

    let(:title) { "00100 accept on port 80" }
    let(:params) do
      {
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "source" => sources
      }
    end

    it {
      is_expected.to contain_firewall("00100 accept on port 80 from #{source}").with(
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "source" => source
      )
    }
  end

  context "when an array of destinations and no source" do
    destinations = %w[
      3.3.3.3/24
      4.4.4.4/24
    ]

    let(:title) { "00100 accept on port 80" }
    let(:params) do
      {
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "destination" => destinations
      }
    end

    it {
      is_expected.to contain_firewall(
        "00100 accept on port 80 to 4.4.4.4/24"
      ).with(
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "destination" => "4.4.4.4/24"
      )
    }
  end

  context "when an array of destinations with a single source" do
    destinations = %w[
      3.3.3.3/24
      4.4.4.4/24
    ]

    source      = "1.1.1.1/24"
    destination = "3.3.3.3/24"

    let(:title) { "00100 accept on port 80" }
    let(:params) do
      {
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "source"      => source,
        "destination" => destinations
      }
    end

    it {
      is_expected.to contain_firewall(
        "00100 accept on port 80 to #{destination}"
      ).with(
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "source"      => source,
        "destination" => destination
      )
    }
  end

  context "when an array of protocols" do
    protocols = %w[tcp udp]

    let(:title) { "00100 accept on port 53" }
    let(:params) do
      {
        "action" => "accept",
        "dport"  => "53",
        "proto"  => protocols
      }
    end

    protocols.each do |protocol|
      it {
        is_expected.to contain_firewall(
          "00100 accept on port 53 protocol #{protocol}"
        ).with(
          "action" => "accept",
          "dport"  => "53",
          "proto"  => protocol
        )
      }
    end
  end

  context "when an array of icmp" do
    icmps = %w[0 8]

    let(:title) { "00100 accept output" }
    let(:params) do
      {
        "chain"  => "OUTPUT",
        "proto"  => "icmp",
        "action" => "accept",
        "icmp"   => icmps
      }
    end

    icmps.each do |icmp|
      it {
        is_expected.to contain_firewall(
          "00100 accept output icmp type #{icmp}"
        ).with(
          "chain"  => "OUTPUT",
          "proto"  => "icmp",
          "action" => "accept",
          "icmp"   => icmp
        )
      }
    end
  end

  context "when an array of icmp as integers" do
    icmps = [0, 8]

    let(:title) { "00100 accept output" }
    let(:params) do
      {
        "chain"  => "OUTPUT",
        "proto"  => "icmp",
        "action" => "accept",
        "icmp"   => icmps
      }
    end

    it {
      is_expected.to contain_firewall("00100 accept output icmp type 8").with(
        "chain"  => "OUTPUT",
        "proto"  => "icmp",
        "action" => "accept",
        "icmp"   => "8"
      )
    }
  end

  # if none of our allowed array inputs are passed then a firewall_multi should
  # spawn one identical firewall resource.

  context "when none of the array functionality is used" do
    let(:title) { "00100 accept on port 80" }
    let(:params) do
      {
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp"
      }
    end

    it {
      is_expected.to contain_firewall("00100 accept on port 80").with(
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp"
      )
    }
  end

  context "when an undef is passed in somewhere" do
    let(:title) { "00100 accept on port 80" }
    let(:params) do
      {
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "source" => nil
      }
    end

    it {
      is_expected.to contain_firewall("00100 accept on port 80").with(
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "source" => "nil"
      )
    }
  end

  context "when passes dst_range through" do
    sources = %w[
      1.1.1.1/24
      2.2.2.2/24
    ]
    dst_range = "3.3.3.3-3.3.3.10"

    let(:title) { "00100 accept on port 80" }
    let(:params) do
      {
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "source" => sources,
        "dst_range" => dst_range
      }
    end

    it {
      is_expected.to contain_firewall(
        "00100 accept on port 80 from 1.1.1.1/24"
      ).with(
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "source" => "1.1.1.1/24",
        "dst_range" => dst_range
      )
    }
  end

  context "when using two providers" do
    providers = %w[
      iptables
      ip6tables
    ]

    let(:title) { "00100 accept on ports 80 and 443" }
    let(:params) do
      {
        "action" => "accept",
        "dport"  => %w[80 443],
        "proto"  => "tcp",
        "provider" => providers
      }
    end

    it {
      providers.each do |provider|
        is_expected.to contain_firewall(
          "00100 accept on ports 80 and 443 using provider #{provider}"
        ).with(
          "action"   => "accept",
          "dport"    => %w[80 443],
          "proto"    => "tcp",
          "provider" => provider
        )
      end
    }
  end

  context "with Issue 19" do
    let(:title) { "00100 accept on port 80" }
    let(:params) do
      {
        "action" => "accept",
        "dport"  => "80",
        "proto"  => "tcp",
        "source"      => "1.1.1.1/24",
        "destination" => "3.3.3.3/24",
        "bytecode"    => "4,48 0 0 9,21 0 1 6,6 0 0 1,6 0 0 0"
      }
    end

    it {
      is_expected.to contain_firewall("00100 accept on port 80").with(
        "action"      => "accept",
        "dport"       => "80",
        "proto"       => "tcp",
        "source"      => "1.1.1.1/24",
        "destination" => "3.3.3.3/24",
        "bytecode"    => "4,48 0 0 9,21 0 1 6,6 0 0 1,6 0 0 0"
      )
    }
  end
end
