require "spec_helper"

describe "firewall_multi" do
  context "when given a wrong number of arguments" do
    it "is expected to fail" do
      expect {
        subject.execute({}, {})
      }.to raise_error ArgumentError, /expects 1 argument, got 2/
    end
  end

  context "when passed a hash" do
    input = {
      "00100 accept inbound ssh" => {
        "jump" => "accept",
        "source" => ["1.1.1.1/24", "2.2.2.2/24"],
        "dport"  => 22
      }
    }

    output = {
      "00100 accept inbound ssh from 1.1.1.1/24" => {
        "jump" => "accept",
        "source" => "1.1.1.1/24",
        "dport"  => 22
      },
      "00100 accept inbound ssh from 2.2.2.2/24" => {
        "jump" => "accept",
        "source" => "2.2.2.2/24",
        "dport"  => 22
      }
    }

    it "is expected to convert hash into expected format" do
      expect(subject.execute(input)).to eq output
    end
  end
end
